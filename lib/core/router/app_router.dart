import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/splash/presentation/screens/splash_screen.dart';
import 'package:notidea/features/auth/presentation/screens/login_screen.dart';
import 'package:notidea/features/auth/presentation/screens/signup_screen.dart';
import 'package:notidea/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:notidea/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:notidea/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:notidea/features/explore/presentation/screens/explore_screen.dart';
import 'package:notidea/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:notidea/features/profile/presentation/screens/profile_screen.dart';
import 'package:notidea/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:notidea/features/friends/presentation/screens/friends_screen.dart';
import 'package:notidea/features/friends/presentation/screens/add_friend_screen.dart';
import 'package:notidea/features/groups/presentation/screens/groups_screen.dart';
import 'package:notidea/features/groups/presentation/screens/create_group_screen.dart';
import 'package:notidea/features/groups/presentation/screens/group_detail_screen.dart';
import 'package:notidea/features/trash/presentation/screens/trash_screen.dart';
import 'package:notidea/features/shared_notes/presentation/screens/shared_notes_screen.dart';
import 'package:notidea/features/search/presentation/screens/search_screen.dart';
import 'package:notidea/features/settings/presentation/screens/settings_screen.dart';
import 'package:notidea/features/settings/presentation/screens/change_password_screen.dart';
import 'package:notidea/features/legal/presentation/screens/legal_screen.dart';
import 'package:notidea/features/notes/presentation/screens/public_note_screen.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final authListenable = ValueNotifier<bool>(true);

  // Profile check cache: keyed by userId, avoids Supabase query on every navigation.
  String? _cachedUserId;
  bool? _cachedHasProfile;

  final sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedIn ||
        data.event == AuthChangeEvent.signedOut) {
      // Invalidate profile cache on auth change.
      _cachedUserId = null;
      _cachedHasProfile = null;
      authListenable.value = !authListenable.value;
    }
  });

  ref.onDispose(() {
    sub.cancel();
    authListenable.dispose();
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: authListenable,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) async {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuthenticated = session != null;
      final currentPath = state.uri.path;

      final isAuthRoute =
          currentPath == RoutePaths.login || currentPath == RoutePaths.signup;
      final isPublicNote = currentPath.startsWith('/n/');
      final isLegalRoute =
          currentPath == RoutePaths.appTerms ||
          currentPath == RoutePaths.appPrivacy;
      final isSplash = currentPath == RoutePaths.splash;
      final isProfileSetup = currentPath == RoutePaths.profileSetup;

      if (!isAuthenticated &&
          !isAuthRoute &&
          !isSplash &&
          !isLegalRoute &&
          !isPublicNote) {
        return RoutePaths.login;
      }

      if (!isAuthenticated) return null;

      // Use cached result when available to prevent per-navigation DB queries.
      final userId = session!.user.id;
      bool hasProfile;
      if (_cachedUserId == userId && _cachedHasProfile != null) {
        hasProfile = _cachedHasProfile!;
      } else {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('id, username')
            .eq('id', userId)
            .maybeSingle();
        hasProfile = profile != null &&
            profile['username'] != null &&
            (profile['username'] as String).isNotEmpty;
        _cachedUserId = userId;
        _cachedHasProfile = hasProfile;
      }

      if (!hasProfile && !isProfileSetup) {
        return RoutePaths.profileSetup;
      }

      if (hasProfile && (isAuthRoute || isSplash || isProfileSetup)) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutePaths.profileSetup,
        name: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: RoutePaths.appTerms,
        name: RouteNames.appTerms,
        builder: (context, state) => const LegalScreen(
          documentType: LegalDocumentType.termsOfService,
        ),
      ),
      GoRoute(
        path: RoutePaths.appPrivacy,
        name: RouteNames.appPrivacy,
        builder: (context, state) => const LegalScreen(
          documentType: LegalDocumentType.privacyPolicy,
        ),
      ),
      GoRoute(
        path: RoutePaths.publicNote,
        name: RouteNames.publicNote,
        builder: (context, state) {
          final noteId = state.pathParameters['noteId']!;
          return PublicNoteScreen(noteId: noteId);
        },
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const NotesListScreen(),
            routes: [
              GoRoute(
                path: RoutePaths.noteEditor,
                name: RouteNames.noteEditor,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const NoteEditorScreen(),
              ),
              GoRoute(
                path: '${RoutePaths.noteEditor}/:noteId',
                name: '${RouteNames.noteEditor}WithId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final noteId = state.pathParameters['noteId']!;
                  final initialNote = state.extra is NoteModel
                      ? state.extra! as NoteModel
                      : null;
                  return NoteEditorScreen(
                    noteId: noteId,
                    initialNote: initialNote?.id == noteId ? initialNote : null,
                  );
                },
              ),

              GoRoute(
                path: RoutePaths.trash,
                name: RouteNames.trash,
                builder: (context, state) => const TrashScreen(),
              ),
              GoRoute(
                path: RoutePaths.sharedNotes,
                name: RouteNames.sharedNotes,
                builder: (context, state) => const SharedNotesScreen(),
              ),
              GoRoute(
                path: RoutePaths.search,
                name: RouteNames.search,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),

          GoRoute(
            path: RoutePaths.explore,
            name: RouteNames.explore,
            builder: (context, state) => const ExploreScreen(),
          ),

          GoRoute(
            path: RoutePaths.favorites,
            name: RouteNames.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),

          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: RoutePaths.editProfile,
                name: RouteNames.editProfile,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'user/:userId',
                name: RouteNames.userProfile,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return ProfileScreen(userId: userId);
                },
              ),
              GoRoute(
                path: RoutePaths.friends,
                name: RouteNames.friends,
                builder: (context, state) => const FriendsScreen(),
                routes: [
                  GoRoute(
                    path: RoutePaths.addFriend,
                    name: RouteNames.addFriend,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AddFriendScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: RoutePaths.groups,
                name: RouteNames.groups,
                builder: (context, state) => const GroupsScreen(),
                routes: [
                  GoRoute(
                    path: RoutePaths.createGroup,
                    name: RouteNames.createGroup,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CreateGroupScreen(),
                  ),
                  GoRoute(
                    path: 'group/:groupId',
                    name: RouteNames.groupDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId']!;
                      return GroupDetailScreen(groupId: groupId);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: RoutePaths.settings,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: RoutePaths.changePassword,
                    name: RouteNames.changePassword,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  GoRoute(
                    path: 'privacy-policy',
                    name: RouteNames.privacyPolicy,
                    builder: (context, state) => const LegalScreen(
                      documentType: LegalDocumentType.privacyPolicy,
                    ),
                  ),
                  GoRoute(
                    path: 'terms-of-service',
                    name: RouteNames.termsOfService,
                    builder: (context, state) => const LegalScreen(
                      documentType: LegalDocumentType.termsOfService,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
