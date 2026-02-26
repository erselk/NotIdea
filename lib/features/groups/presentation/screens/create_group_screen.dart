import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/friends/presentation/widgets/friend_card.dart';
import 'package:notidea/features/groups/presentation/providers/groups_provider.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/search/presentation/providers/search_provider.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  final _selectedMemberIds = <String>{};
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    final created = await ref.read(createGroupProvider.notifier).execute(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          memberIds: _selectedMemberIds.toList(),
        );

    if (created != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final createState = ref.watch(createGroupProvider);
    final friendsAsync = ref.watch(friendsListProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    ref.listen(createGroupProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.groupCreated)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createGroup),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: createState.isLoading ? null : _createGroup,
              child: createState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.createGroup),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.groupName,
                filled: true,
                fillColor: appColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.groupNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.groupDescription,
                filled: true,
                fillColor: appColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.people, size: 20, color: appColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  l10n.selectMembers,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appColors.textSecondary,
                  ),
                ),
                if (_selectedMemberIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Chip(
                      label: Text('${_selectedMemberIds.length}'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
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
                    children: friends.map((friendship) {
                      final friendProfile = _getFriendProfile(
                        friendship,
                        currentUser?.id ?? '',
                      );
                      if (friendProfile == null) {
                        return const SizedBox.shrink();
                      }
                      return _buildUserItem(friendProfile);
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
                      return _buildUserItem(user);
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(ProfileModel profile) {
    final isSelected = _selectedMemberIds.contains(profile.id);

    return FriendCard(
      profile: profile,
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedMemberIds.remove(profile.id);
          } else {
            _selectedMemberIds.add(profile.id);
          }
        });
      },
      trailing: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedMemberIds.add(profile.id);
            } else {
              _selectedMemberIds.remove(profile.id);
            }
          });
        },
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
