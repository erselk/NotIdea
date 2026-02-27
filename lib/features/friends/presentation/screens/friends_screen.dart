import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/friends/domain/models/friendship_model.dart';
import 'package:notidea/features/friends/domain/models/friendship_status.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/friends/presentation/widgets/friend_card.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/shared/widgets/branded_app_bar.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: BrandedAppBar(
        titleFirst: 'Fri',
        titleSecond: 'ends',
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.friends),
            Tab(text: l10n.pendingRequests),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FriendsTab(appColors: appColors),
          _PendingTab(appColors: appColors),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.addFriend),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.addFriend),
      ),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({required this.appColors});

  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsListProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(friendsListProvider),
      child: friendsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(error.toString(), style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(friendsListProvider),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (friends) {
          if (friends.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 72,
                      color: appColors.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noFriends,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noFriendsDesc,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final currentUserId = currentUserAsync.value?.id;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: friends.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 72,
              color: appColors.divider,
            ),
            itemBuilder: (context, index) {
              final friendship = friends[index];
              final friendProfile = _getFriendProfile(
                friendship,
                currentUserId ?? '',
              );

              if (friendProfile == null) return const SizedBox.shrink();

              return Dismissible(
                key: ValueKey(friendship.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: theme.colorScheme.error,
                  child: Icon(Icons.person_remove, color: theme.colorScheme.onError),
                ),
                confirmDismiss: (_) => _confirmRemove(context, l10n),
                onDismissed: (_) {
                  ref
                      .read(removeFriendProvider.notifier)
                      .execute(friendship.id);
                },
                child: FriendCard(
                  profile: friendProfile,
                  onTap: () => context.pushNamed(
                    RouteNames.userProfile,
                    pathParameters: {'userId': friendProfile.id},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _getFriendProfile(FriendshipModel friendship, String currentUserId) {
    if (friendship.requesterId == currentUserId) {
      return friendship.addresseeProfile;
    }
    return friendship.requesterProfile;
  }

  Future<bool?> _confirmRemove(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeFriend),
        content: Text(l10n.confirmRemoveFriend),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.removeFriend),
          ),
        ],
      ),
    );
  }
}

class _PendingTab extends ConsumerWidget {
  const _PendingTab({required this.appColors});

  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(pendingRequestsProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    ref.listen(acceptFriendRequestProvider, (prev, next) {
      if (next.hasError) {
        context.showError(next.error);
      }
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        context.showSuccess(l10n.friendRequestAccepted);
      }
    });

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(pendingRequestsProvider),
      child: pendingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error.toString()),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(pendingRequestsProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (requests) {
          if (requests.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      size: 72,
                      color: appColors.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noFriendRequests,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final currentUserId = currentUserAsync.value?.id ?? '';

          final incoming = requests
              .where((r) =>
                  r.addresseeId == currentUserId &&
                  r.status == FriendshipStatus.pending)
              .toList();
          final outgoing = requests
              .where((r) =>
                  r.requesterId == currentUserId &&
                  r.status == FriendshipStatus.pending)
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (incoming.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    l10n.friendRequests,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: appColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...incoming.map((request) {
                  final profile = request.requesterProfile;
                  if (profile == null) return const SizedBox.shrink();

                  return FriendCard(
                    profile: profile,
                    onTap: () => context.pushNamed(
                      RouteNames.userProfile,
                      pathParameters: {'userId': profile.id},
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                          onPressed: () => ref
                              .read(acceptFriendRequestProvider.notifier)
                              .execute(request.id),
                          icon: const Icon(Icons.check, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: appColors.success,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.outlined(
                          onPressed: () => ref
                              .read(rejectFriendRequestProvider.notifier)
                              .execute(request.id),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              if (outgoing.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    l10n.sentRequests,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: appColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...outgoing.map((request) {
                  final profile = request.addresseeProfile;
                  if (profile == null) return const SizedBox.shrink();

                  return FriendCard(
                    profile: profile,
                    onTap: () => context.pushNamed(
                      RouteNames.userProfile,
                      pathParameters: {'userId': profile.id},
                    ),
                    trailing: TextButton(
                      onPressed: () => ref
                          .read(rejectFriendRequestProvider.notifier)
                          .execute(request.id),
                      child: Text(l10n.cancelRequest),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }
}
