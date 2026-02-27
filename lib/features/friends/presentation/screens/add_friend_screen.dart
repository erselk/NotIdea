import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/friends/presentation/widgets/friend_card.dart';

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _searchQuery = value.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    ref.listen(sendFriendRequestProvider, (prev, next) {
      if (next.hasError) {
        context.showError(next.error);
      }
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        context.showSuccess(l10n.friendRequestSent);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addFriend),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChanged,
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
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchQuery.length < 2
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 72,
                            color: appColors.primary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.searchUsers,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _SearchResults(query: _searchQuery),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final searchAsync = ref.watch(searchUsersProvider(query));
    final sendState = ref.watch(sendFriendRequestProvider);
    final friendsList = ref.watch(friendsListProvider).value ?? [];
    final pendingList = ref.watch(pendingRequestsProvider).value ?? [];

    return searchAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(error.toString(), style: theme.textTheme.bodyMedium),
      ),
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 56,
                    color: appColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noSearchResults,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noSearchResultsDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: users.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 72,
            color: appColors.divider,
          ),
          itemBuilder: (context, index) {
            final user = users[index];
            final isFriend = friendsList.any(
                (f) => f.requesterId == user.id || f.addresseeId == user.id);
            final isPending = pendingList.any(
                (f) => f.requesterId == user.id || f.addresseeId == user.id);

            Widget trailing;
            if (isFriend) {
              trailing = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: appColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(l10n.statusFriend, style: TextStyle(color: appColors.primary)),
                ],
              );
            } else if (isPending) {
              trailing = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, color: appColors.textTertiary, size: 16),
                  const SizedBox(width: 4),
                  Text(l10n.statusPending, style: TextStyle(color: appColors.textTertiary)),
                ],
              );
            } else {
              trailing = FilledButton.tonal(
                onPressed: sendState.isLoading
                    ? null
                    : () => ref
                        .read(sendFriendRequestProvider.notifier)
                        .execute(user.id),
                child: sendState.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.sendFriendRequest),
              );
            }

            return FriendCard(
              profile: user,
              trailing: trailing,
            );
          },
        );
      },
    );
  }
}
