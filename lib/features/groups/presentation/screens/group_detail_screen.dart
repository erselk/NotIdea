import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/groups/domain/models/group_member_role.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/groups/presentation/providers/groups_provider.dart';

class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final groupAsync = ref.watch(groupByIdProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final currentUser = ref.watch(currentUserProvider).value;

    ref.listen(deleteGroupProvider, (prev, next) {
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        context.showSuccess(l10n.groupDeleted);
        context.pop();
      }
    });

    return Scaffold(
      body: groupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(error.toString()),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(groupByIdProvider(groupId)),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (group) {
          if (group == null) {
            return Center(child: Text(l10n.errorGeneral));
          }

          final isOwner = group.ownerId == currentUser?.id;

          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text(group.name),
                actions: [
                  if (isOwner)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showEditDialog(context, ref, l10n, appColors);
                            break;
                          case 'delete':
                            _confirmDeleteGroup(
                                context, ref, l10n, theme, group.id);
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: Text(l10n.editGroup),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete,
                                color: theme.colorScheme.error),
                            title: Text(l10n.deleteGroup,
                                style: TextStyle(
                                    color: theme.colorScheme.error)),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Group Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: appColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: appColors.border.withValues(alpha: 0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: appColors.primaryLight,
                                child: Icon(Icons.group,
                                    size: 28, color: appColors.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.memberCount(group.memberCount),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: appColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (group.description != null &&
                              group.description!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              group.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Members Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        l10n.members,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: appColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (isOwner)
                        TextButton.icon(
                          onPressed: () =>
                              _showAddMemberSheet(context, ref, l10n, appColors),
                          icon: const Icon(Icons.person_add, size: 18),
                          label: Text(l10n.addMembers),
                        ),
                    ],
                  ),
                ),
              ),

              // Members List
              membersAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text(e.toString())),
                ),
                data: (members) {
                  if (members.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.noMembersYet,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: appColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final member = members[index];
                        final profile = member.profile;
                        final roleLabel = switch (member.role) {
                          GroupMemberRole.owner => l10n.owner,
                          GroupMemberRole.admin => l10n.admin,
                          GroupMemberRole.member => '',
                        };

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: appColors.surfaceVariant,
                            backgroundImage: profile?.avatarUrl != null
                                ? CachedNetworkImageProvider(
                                    profile!.avatarUrl!)
                                : null,
                            child: profile?.avatarUrl == null
                                ? Text(
                                    () {
                                      final n = profile?.displayNameOrUsername ?? '?';
                                      return n.isNotEmpty ? n[0].toUpperCase() : '?';
                                    }(),
                                    style: TextStyle(color: appColors.primary),
                                  )
                                : null,
                          ),
                          title: Text(
                            profile?.displayNameOrUsername ?? member.userId,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: profile?.username != null
                              ? Text(
                                  '@${profile!.username}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textTertiary,
                                  ),
                                )
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (roleLabel.isNotEmpty)
                                Chip(
                                  label: Text(
                                    roleLabel,
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ),
                              if (isOwner &&
                                  member.role != GroupMemberRole.owner)
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: theme.colorScheme.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(removeGroupMemberProvider.notifier)
                                        .execute(
                                          groupId: groupId,
                                          userId: member.userId,
                                        );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                      childCount: members.length,
                    ),
                  );
                },
              ),

              // Leave Group Button
              if (!isOwner)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _confirmLeaveGroup(context, ref, l10n, theme),
                      icon: Icon(Icons.exit_to_app,
                          color: theme.colorScheme.error),
                      label: Text(
                        l10n.leaveGroup,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          );
        },
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppColorsExtension appColors,
  ) {
    final group = ref.read(groupByIdProvider(groupId)).value;
    if (group == null) return;

    final nameController = TextEditingController(text: group.name);
    final descController = TextEditingController(text: group.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editGroup),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.groupName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.groupDescription),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(updateGroupProvider.notifier).execute(
                    group.copyWith(
                      name: nameController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                    ),
                  );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteGroup),
        content: Text(l10n.confirmDeleteGroup),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(deleteGroupProvider.notifier).execute(id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.leaveGroup),
        content: Text(l10n.confirmLeaveGroup),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final userId = ref.read(currentUserProvider).value?.id;
              if (userId != null) {
                ref.read(removeGroupMemberProvider.notifier).execute(
                      groupId: groupId,
                      userId: userId,
                    );
                context.pop();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.leaveGroup),
          ),
        ],
      ),
    );
  }

  void _showAddMemberSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppColorsExtension appColors,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return _AddMemberSheet(
            groupId: groupId,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

class _AddMemberSheet extends ConsumerWidget {
  const _AddMemberSheet({
    required this.groupId,
    required this.scrollController,
  });

  final String groupId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final friendsAsync = ref.watch(friendsListProvider);
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final currentUser = ref.watch(currentUserProvider).value;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                l10n.addMembers,
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
          child: friendsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (friends) {
              final existingMemberIds = membersAsync.value
                      ?.map((m) => m.userId)
                      .toSet() ??
                  <String>{};

              final availableFriends = friends.where((f) {
                final friendId = f.requesterId == currentUser?.id
                    ? f.addresseeId
                    : f.requesterId;
                return !existingMemberIds.contains(friendId);
              }).toList();

              if (availableFriends.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noFriends,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: availableFriends.length,
                itemBuilder: (context, index) {
                  final friendship = availableFriends[index];
                  final friendId =
                      friendship.requesterId == currentUser?.id
                          ? friendship.addresseeId
                          : friendship.requesterId;
                  final profile =
                      friendship.requesterId == currentUser?.id
                          ? friendship.addresseeProfile
                          : friendship.requesterProfile;

                  if (profile == null) return const SizedBox.shrink();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: appColors.surfaceVariant,
                      backgroundImage: profile.avatarUrl != null
                          ? CachedNetworkImageProvider(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? Text(
                              profile.displayNameOrUsername.isNotEmpty
                                  ? profile.displayNameOrUsername[0].toUpperCase()
                                  : '?',
                              style: TextStyle(color: appColors.primary),
                            )
                          : null,
                    ),
                    title: Text(profile.displayNameOrUsername),
                    subtitle: Text('@${profile.username}'),
                    trailing: FilledButton.tonal(
                      onPressed: () {
                        ref.read(addGroupMemberProvider.notifier).execute(
                              groupId: groupId,
                              userId: friendId,
                            );
                        Navigator.pop(context);
                      },
                      child: Text(l10n.addMembers),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
