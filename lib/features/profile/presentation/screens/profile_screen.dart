import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';
import 'package:notidea/features/profile/presentation/providers/profile_stats_provider.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);

    final isOwnProfile =
        userId == null || userId == currentUserAsync.value?.id;

    final profileAsync = isOwnProfile
        ? ref.watch(currentProfileProvider)
        : ref.watch(profileByIdProvider(userId!));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: isOwnProfile
            ? Padding(
                padding: const EdgeInsets.only(left: 14, top: 8),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: Icon(Icons.menu, color: theme.colorScheme.onPrimary, size: 28),
                      onPressed: () => AppScaffold.openDrawer(context),
                    ),
                  ),
                ),
              )
            : BackButton(color: theme.colorScheme.onPrimary),
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
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    height: 150, // Resmin tam ortasinda hizalanacak seviyeye daraltildi
                    width: double.infinity,
                    color: theme.colorScheme.primary,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 70), // Push avatar higher up
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80, // Increased size
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            backgroundImage: profile.avatarUrl != null
                                ? CachedNetworkImageProvider(profile.avatarUrl!)
                                : null,
                            child: profile.avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 80,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  )
                                : null,
                          ),
                          if (isOwnProfile)
                            Positioned(
                              bottom: 0, // was 8
                              right: 0, // was 8
                              child: GestureDetector(
                                onTap: () => context.push('/profile/edit'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary, // Green background
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(7), // Smaller padding for smaller circle
                                  child: Icon(
                                    Icons.edit,
                                    size: 20, // Keep icon size same
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 28), // Üst boşluk arttirildi

                      // Display name
                      Text(
                        profile.displayNameOrUsername,
                        style: GoogleFonts.poppins(
                          fontSize: 24, // 1. Display Name
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2), // Alt boşluk düşürüldü
                      Text(
                        '@${profile.username}',
                        style: GoogleFonts.poppins(
                          fontSize: 16, // 2. Username
                          fontWeight: FontWeight.w300,
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
                      Consumer(
                        builder: (context, ref, child) {
                          final statsAsync = ref.watch(profileStatsProvider(profile.id));
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StatItem(
                                count: statsAsync.value?.noteCount ?? 0,
                                label: 'Notes',
                                theme: theme,
                              ),
                              const SizedBox(width: 48),
                              _StatItem(
                                count: statsAsync.value?.friendCount ?? 0,
                                label: l10n.friends,
                                theme: theme,
                              ),
                              const SizedBox(width: 48),
                              _StatItem(
                                count: statsAsync.value?.groupCount ?? 0,
                                label: 'Groups',
                                theme: theme,
                              ),
                            ],
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60), // Uzatıldı
                        child: Divider(
                          color: theme.colorScheme.primary, 
                          thickness: 3, // Hafif Kalınlaştırıldı
                        ),
                      ),
                      const SizedBox(height: 24), // Alt bosluk arttirildi

                      // Action button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80, top: 8, bottom: 24), // Ortaya doğru daha da itildi
                          child: InkWell(
                            onTap: () {
                              if (isOwnProfile) {
                                context.push('/profile/edit');
                              } else {
                                ref.read(sendFriendRequestProvider.notifier).execute(profile.id);
                                context.showSuccess(l10n.friendRequestSent);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isOwnProfile ? Icons.edit_outlined : Icons.person_add_outlined, 
                                    color: theme.colorScheme.primary, // Green icon
                                    size: 28 // Büyütüldü
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isOwnProfile ? l10n.editProfile : l10n.addFriend,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16, // 5. Action Text
                                      fontWeight: FontWeight.w400, // Regular weight
                                      color: theme.colorScheme.onSurface, // Siyah/Tema rengi
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ], // Column children
              ), // Column
            ], // Stack children
          ), // Stack
        ), // SingleChildScrollView
      ); // RefreshIndicator
    }, // data callback
      ), // profileAsync.when
    ); // Scaffold
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
          count.toString().padLeft(2, '0'),
          style: GoogleFonts.poppins(
            fontSize: 16, // 3. Stats Title
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14, // 4. Stats Subtitle
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

