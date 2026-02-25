import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';

class AppScaffold extends ConsumerStatefulWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  static void openDrawer(BuildContext context) {
    context.findAncestorStateOfType<_AppScaffoldState>()?.openDrawer();
  }

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerScrimColor: const Color(0xFF374241).withOpacity(0.12),
      drawer: const _AppDrawer(),
      body: widget.child,
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  static const _green = Color(0xFF06A74D);
  static const _selectedBg = Color(0xFFE5EAE4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.value;
    final currentPath = GoRouterState.of(context).uri.path;
    final selectedIdx = _selectedIndex(currentPath);

    final displayName = profile?.displayName ?? profile?.username ?? '';
    final avatarUrl = profile?.avatarUrl;

    final menuItems = [
      _MenuItem(Icons.note_alt_outlined, 'Notes'),
      _MenuItem(Icons.explore_outlined, l10n.explore),
      _MenuItem(Icons.favorite_outline_rounded, l10n.favorites),
      _MenuItem(Icons.person_outline_rounded, l10n.profile),
      _MenuItem(Icons.people_outline_rounded, l10n.friends),
      _MenuItem(Icons.group_work_outlined, l10n.groups),
      _MenuItem(Icons.share_outlined, l10n.sharedWithMe),
      _MenuItem(Icons.delete_outline_rounded, l10n.trash),
      _MenuItem(Icons.settings_outlined, l10n.settings),
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.61,
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Üst kısım: geri butonu (Menü butonu ile aynı hizada) ───
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: _green, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),

              // ─── Profil resmi ───
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(RouteNames.profile);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  backgroundImage: avatarUrl != null
                      ? CachedNetworkImageProvider(avatarUrl)
                      : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: theme.colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
              ),

              // ─── Görünen ad ───
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ─── Yeşil çizgi ───
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1, thickness: 2, color: _green),
              ),
              const SizedBox(height: 24),

              // ─── Menü listesi ───
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    final isSelected = index == selectedIdx;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Material(
                        color: isSelected ? _selectedBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).pop();
                            _onDestinationSelected(index, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(item.icon, size: 24, color: _green),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectedIndex(String path) {
    if (path.startsWith(RoutePaths.home)) {
      if (path.contains('shared')) return 6;
      if (path.contains('trash')) return 7;
      return 0;
    }
    if (path.startsWith(RoutePaths.explore)) return 1;
    if (path.startsWith(RoutePaths.favorites)) return 2;
    if (path.startsWith(RoutePaths.profile)) {
      if (path.contains('friends')) return 4;
      if (path.contains('groups')) return 5;
      if (path.contains('settings')) return 8;
      return 3;
    }
    return 0;
  }

  void _onDestinationSelected(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
      case 1:
        context.goNamed(RouteNames.explore);
      case 2:
        context.goNamed(RouteNames.favorites);
      case 3:
        context.goNamed(RouteNames.profile);
      case 4:
        context.go('/profile/friends');
      case 5:
        context.go('/profile/groups');
      case 6:
        context.go('/home/shared');
      case 7:
        context.go('/home/trash');
      case 8:
        context.go('/profile/settings');
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}

