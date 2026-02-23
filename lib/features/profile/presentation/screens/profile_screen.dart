import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);

    final isOwnProfile =
        userId == null || userId == currentUserAsync.valueOrNull?.id;

    final profileAsync = isOwnProfile
        ? ref.watch(currentProfileProvider)
        : ref.watch(profileByIdProvider(userId!));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/profile/edit'),
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(l10n.errorLoadingProfile),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    if (isOwnProfile) {
                      ref.invalidate(currentProfileProvider);
                    } else {
                      ref.invalidate(profileByIdProvider(userId!));
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.profileNotFound));
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (isOwnProfile) {
                ref.invalidate(currentProfileProvider);
              } else {
                ref.invalidate(profileByIdProvider(userId!));
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: AppConstants.avatarSizeXLarge / 2,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        backgroundImage: profile.avatarUrl != null
                            ? CachedNetworkImageProvider(profile.avatarUrl!)
                            : null,
                        child: profile.avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: AppConstants.avatarSizeXLarge / 2,
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            : null,
                      ),
                      if (isOwnProfile)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: theme.colorScheme.onPrimary,
                              ),
                              onPressed: () =>
                                  context.push('/profile/edit'),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Display name
                  Text(
                    profile.displayName ?? profile.username,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${profile.username}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  // Bio
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        profile.bio!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatItem(
                        count: profile.noteCount,
                        label: l10n.notes,
                        theme: theme,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        color: theme.colorScheme.outlineVariant,
                      ),
                      _StatItem(
                        count: profile.friendCount,
                        label: l10n.friends,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  if (isOwnProfile)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/profile/edit'),
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.editProfile),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: Arkadaş ekleme
                        },
                        icon: const Icon(Icons.person_add_outlined),
                        label: Text(l10n.addFriend),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Tabs
                  DefaultTabController(
                    length: isOwnProfile ? 3 : 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: l10n.myNotes),
                            Tab(text: l10n.publicNotes),
                            if (isOwnProfile) Tab(text: l10n.sharedWithMe),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [
                              _PlaceholderTab(
                                icon: Icons.note_outlined,
                                label: l10n.myNotes,
                                theme: theme,
                              ),
                              _PlaceholderTab(
                                icon: Icons.public,
                                label: l10n.publicNotes,
                                theme: theme,
                              ),
                              if (isOwnProfile)
                                _PlaceholderTab(
                                  icon: Icons.share_outlined,
                                  label: l10n.sharedWithMe,
                                  theme: theme,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int count;
  final String label;
  final ThemeData theme;

  const _StatItem({
    required this.count,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _PlaceholderTab({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
