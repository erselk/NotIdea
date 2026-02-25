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

  @override
  void initState() {
    super.initState();
    _selectedVisibility = widget.note.visibility;
  }

  Future<void> _updateVisibility(NoteVisibility visibility) async {
    setState(() => _selectedVisibility = visibility);
    await ref.read(updateNoteProvider.notifier).execute(
          widget.note.copyWith(visibility: visibility),
        );
  }

  Future<void> _shareWithUser(String userId) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    await SupabaseConfig.client.from('note_shares').insert({
      'note_id': widget.note.id,
      'shared_by_user_id': currentUser.id,
      'shared_with_user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteShared)),
      );
    }
  }

  Future<void> _shareWithGroup(String groupId) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    await SupabaseConfig.client.from('note_shares').insert({
      'note_id': widget.note.id,
      'shared_by_user_id': currentUser.id,
      'shared_with_group_id': groupId,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteShared)),
      );
    }
  }

  void _copyLink() {
    final link = '${AppConstants.baseUrl}/n/${widget.note.id}';
    Clipboard.setData(ClipboardData(text: link));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.linkCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final friendsAsync = ref.watch(friendsListProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return Column(
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appColors.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

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
              // Visibility Selector
              Text(
                l10n.noteVisibility,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _VisibilityOption(
                icon: Icons.lock_outline,
                label: l10n.visibilityPrivate,
                description: l10n.visibilityPrivateDesc,
                isSelected: _selectedVisibility == NoteVisibility.private_,
                appColors: appColors,
                onTap: () => _updateVisibility(NoteVisibility.private_),
              ),
              _VisibilityOption(
                icon: Icons.people_outline,
                label: l10n.visibilityFriends,
                description: l10n.visibilitySharedDesc,
                isSelected: _selectedVisibility == NoteVisibility.friends,
                appColors: appColors,
                onTap: () => _updateVisibility(NoteVisibility.friends),
              ),
              _VisibilityOption(
                icon: Icons.public,
                label: l10n.visibilityPublic,
                description: l10n.visibilityPublicDesc,
                isSelected: _selectedVisibility == NoteVisibility.public_,
                appColors: appColors,
                onTap: () => _updateVisibility(NoteVisibility.public_),
              ),

              const SizedBox(height: 16),
              Divider(color: appColors.divider),
              const SizedBox(height: 16),

              // Share via Link
              OutlinedButton.icon(
                onPressed: _copyLink,
                icon: const Icon(Icons.link),
                label: Text(l10n.copyLink),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Share with Friends
              Text(
                l10n.shareWithFriends,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              friendsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(e.toString()),
                data: (friends) {
                  if (friends.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        l10n.noFriends,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textTertiary,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: friends.map((friendship) {
                      final friendProfile = _getFriendProfile(
                        friendship,
                        currentUser?.id ?? '',
                      );
                      if (friendProfile == null) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: appColors.surfaceVariant,
                          backgroundImage: friendProfile.avatarUrl != null
                              ? CachedNetworkImageProvider(
                                  friendProfile.avatarUrl!)
                              : null,
                          child: friendProfile.avatarUrl == null
                              ? Text(
                                  (friendProfile.displayName ??
                                          friendProfile.username)[0]
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: appColors.primary,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          friendProfile.displayName ?? friendProfile.username,
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          '@${friendProfile.username}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.send, size: 18,
                              color: appColors.primary),
                          onPressed: () =>
                              _shareWithUser(friendProfile.id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Share with Groups
              Text(
                l10n.shareWithGroups,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              groupsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(e.toString()),
                data: (groups) {
                  if (groups.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        l10n.noGroups,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textTertiary,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: groups.map((group) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: appColors.primaryLight,
                          child: Icon(Icons.group, size: 18,
                              color: appColors.primary),
                        ),
                        title: Text(group.name,
                            style: theme.textTheme.bodyMedium),
                        subtitle: Text(
                          l10n.memberCount(group.memberCount),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.send, size: 18,
                              color: appColors.primary),
                          onPressed: () => _shareWithGroup(group.id),
                        ),
                      );
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

  ProfileModel? _getFriendProfile(dynamic friendship, String currentUserId) {
    if (friendship.requesterId == currentUserId) {
      return friendship.addresseeProfile;
    }
    return friendship.requesterProfile;
  }
}

class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.appColors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final AppColorsExtension appColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected
            ? appColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? appColors.primary : appColors.textTertiary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? appColors.primary
                              : appColors.textPrimary,
                        ),
                      ),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, size: 20, color: appColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
