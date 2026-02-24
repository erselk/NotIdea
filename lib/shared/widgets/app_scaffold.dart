import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
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
      drawer: const _AppDrawer(),
      body: widget.child,
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.valueOrNull;
    final currentPath = GoRouterState.of(context).uri.path;

    return NavigationDrawer(
      selectedIndex: _selectedIndex(currentPath),
      onDestinationSelected: (index) {
        Navigator.of(context).pop();
        _onDestinationSelected(index, context);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 16, 16),
          child: _DrawerHeader(profile: profile, theme: theme),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1),
        ),
        const SizedBox(height: 8),
        NavigationDrawerDestination(
          icon: const Icon(Icons.note_alt_outlined),
          selectedIcon: const Icon(Icons.note_alt_rounded),
          label: Text(l10n.myNotes),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.explore_outlined),
          selectedIcon: const Icon(Icons.explore_rounded),
          label: Text(l10n.explore),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.favorite_outline_rounded),
          selectedIcon: const Icon(Icons.favorite_rounded),
          label: Text(l10n.favorites),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: Text(l10n.profile),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(height: 1),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.people_outline_rounded),
          selectedIcon: const Icon(Icons.people_rounded),
          label: Text(l10n.friends),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.group_work_outlined),
          selectedIcon: const Icon(Icons.group_work_rounded),
          label: Text(l10n.groups),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.share_outlined),
          selectedIcon: const Icon(Icons.share_rounded),
          label: Text(l10n.sharedWithMe),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.delete_outline_rounded),
          selectedIcon: const Icon(Icons.delete_rounded),
          label: Text(l10n.trash),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(height: 1),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded),
          label: Text(l10n.settings),
        ),
      ],
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

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.profile,
    required this.theme,
  });

  final ProfileModel? profile;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final displayName = profile?.displayName ?? profile?.username ?? '';
    final username = profile?.username ?? '';
    final avatarUrl = profile?.avatarUrl;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          backgroundImage: avatarUrl != null
              ? CachedNetworkImageProvider(avatarUrl)
              : null,
          child: avatarUrl == null
              ? Icon(
                  Icons.person,
                  size: 28,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (username.isNotEmpty)
                Text(
                  '@$username',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
