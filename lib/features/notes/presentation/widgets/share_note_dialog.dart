import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/groups/presentation/providers/groups_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/search/presentation/providers/search_provider.dart';
import 'package:notidea/config/supabase_config.dart';

class ShareNoteDialog extends ConsumerStatefulWidget {
  const ShareNoteDialog({super.key, required this.note});

  final NoteModel note;

  static Future<void> show(BuildContext context, NoteModel note) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => ShareNoteDialog(note: note),
      ),
    );
  }

  @override
  ConsumerState<ShareNoteDialog> createState() => _ShareNoteDialogState();
}

class _ShareNoteDialogState extends ConsumerState<ShareNoteDialog> {
  late NoteVisibility _selectedVisibility;
  List<Map<String, dynamic>> _currentShares = [];
  bool _isLoadingShares = true;

  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedVisibility = widget.note.visibility;
    _fetchShares();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchShares() async {
    try {
      final data = await SupabaseConfig.client
          .from('note_shares')
          .select()
          .eq('note_id', widget.note.id);
      
      if (mounted) {
        setState(() {
          _currentShares = List<Map<String, dynamic>>.from(data);
          _isLoadingShares = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingShares = false);
    }
  }

  Future<void> _updateVisibility(NoteVisibility visibility) async {
    setState(() => _selectedVisibility = visibility);
    await ref.read(updateNoteProvider.notifier).execute(
          widget.note.copyWith(visibility: visibility),
        );
  }

  Future<void> _shareWithUser(String userId, String permission) async {
    final existingShare = _currentShares.where((s) => s['shared_with_user_id'] == userId).firstOrNull;
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    if (existingShare != null) {
      if (existingShare['permission'] == permission) {
        // Remove access
        await SupabaseConfig.client.from('note_shares').delete().eq('id', existingShare['id']);
        setState(() {
          _currentShares.removeWhere((s) => s['id'] == existingShare['id']);
        });
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erişim kaldırıldı')),
          );
        }
        return;
      } else {
        // Update access level
        final res = await SupabaseConfig.client
            .from('note_shares')
            .update({'permission': permission})
            .eq('id', existingShare['id'])
            .select()
            .single();
        setState(() {
          final idx = _currentShares.indexWhere((s) => s['id'] == existingShare['id']);
          if (idx != -1) _currentShares[idx] = res;
        });
      }
    } else {
      // Add new access
      final res = await SupabaseConfig.client.from('note_shares').insert({
        'note_id': widget.note.id,
        'shared_by_user_id': currentUser.id,
        'shared_with_user_id': userId,
        'permission': permission,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      setState(() {
        _currentShares.add(res);
      });
    }

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existingShare == null ? l10n.noteShared : 'Erişim güncellendi')),
      );
    }
  }

  Future<void> _shareWithGroup(String groupId, String permission) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    await SupabaseConfig.client.from('note_shares').insert({
      'note_id': widget.note.id,
      'shared_by_user_id': currentUser.id,
      'shared_with_group_id': groupId,
      'permission': permission,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteShared)),
      );
    }
  }

  Future<void> _copyLink(String permission) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    try {
      final token = await ref
          .read(createShareLinkProvider.notifier)
          .execute(
            noteId: widget.note.id,
            sharedByUserId: currentUser.id,
            permission: permission,
          );

      final link = '${AppConstants.baseUrl}/n/${widget.note.id}?t=$token';
      await Clipboard.setData(ClipboardData(text: link));

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkCopied)),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final friendsAsync = ref.watch(friendsListProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                l10n.shareNote,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        Divider(height: 1, color: appColors.divider),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bağlantı Paylaş',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _copyLink('read_only'),
                        icon: const Icon(Icons.link, size: 16),
                        label: const Text('İzleme K.', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _copyLink('read_write'),
                        icon: const Icon(Icons.link, size: 16),
                        label: const Text('Düz. K.', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _searchController,
                onChanged: (val) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    setState(() => _searchQuery = val.trim());
                  });
                },
                decoration: InputDecoration(
                  hintText: l10n.searchUsers,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: appColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_searchQuery.length < 2)
                friendsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text(e.toString()),
                  data: (friends) {
                    if (friends.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.noFriends,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: appColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: friends.map((friendship) {
                        final friendProfile = _getFriendProfile(friendship, currentUser?.id ?? '');
                        if (friendProfile == null) return const SizedBox.shrink();
                        
                        return _buildUserItem(friendProfile, theme, appColors);
                      }).toList(),
                    );
                  },
                )
              else
                ref.watch(searchUsersProvider(_searchQuery)).when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text(e.toString()),
                  data: (users) {
                    if (users.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Kullanıcı bulunamadı',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: appColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      children: users.map((user) {
                        return _buildUserItem(user, theme, appColors);
                      }).toList(),
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserItem(ProfileModel profile, ThemeData theme, AppColorsExtension appColors) {
    final existingShare = _currentShares.where((s) => s['shared_with_user_id'] == profile.id).firstOrNull;
    final hasAccess = existingShare != null;
    final permission = hasAccess ? existingShare['permission'] as String? : null;

    final displayName = (profile.displayNameOrUsername);
    final displayInitial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: appColors.surfaceVariant,
        backgroundImage: profile.avatarUrl != null ? CachedNetworkImageProvider(profile.avatarUrl!) : null,
        child: profile.avatarUrl == null
            ? Text(
                displayInitial,
                style: TextStyle(color: appColors.primary, fontSize: 12),
              )
            : null,
      ),
      title: Text(profile.displayNameOrUsername, style: theme.textTheme.bodyMedium),
      subtitle: Text('@${profile.username}', style: theme.textTheme.bodySmall?.copyWith(color: appColors.textTertiary)),
      trailing: PopupMenuButton<String>(
        initialValue: permission,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
             color: appColors.surfaceVariant,
             borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 !hasAccess 
                   ? 'Ekle' 
                   : (permission == 'read_write' ? 'Düzenleyici' : 'İzleyici'),
                 style: TextStyle(
                   color: !hasAccess ? appColors.textSecondary : appColors.primary,
                   fontSize: 12,
                   fontWeight: FontWeight.w500,
                 )
               ),
               const SizedBox(width: 4),
               Icon(Icons.arrow_drop_down, size: 16, color: appColors.textSecondary),
             ]
          ),
        ),
        onSelected: (val) {
           if (val == 'remove') {
              _shareWithUser(profile.id, permission ?? 'read_only');
           } else {
              _shareWithUser(profile.id, val);
           }
        },
        itemBuilder: (context) => [
          if (!hasAccess || permission != 'read_only')
            const PopupMenuItem(value: 'read_only', child: Text('İzleyici yap')),
          if (!hasAccess || permission != 'read_write')
            const PopupMenuItem(value: 'read_write', child: Text('Düzenleyici yap')),
          if (hasAccess)
            const PopupMenuItem(value: 'remove', child: Text('Erişimi Kaldır', style: TextStyle(color: Colors.red))),
        ]
      ),
    );
  }

  ProfileModel? _getFriendProfile(dynamic friendship, String currentUserId) {
    if (friendship.requesterId == currentUserId) {
      return friendship.addresseeProfile;
    }
    return friendship.requesterProfile;
  }
}
