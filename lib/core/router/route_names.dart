/// Tüm rota isim sabitleri
class RouteNames {
  RouteNames._();

  // Giriş akışı
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String profileSetup = 'profileSetup';

  // Ana sekmeler
  static const String home = 'home';
  static const String explore = 'explore';
  static const String favorites = 'favorites';
  static const String profile = 'profile';

  // Notlar
  static const String notesList = 'notesList';
  static const String noteEditor = 'noteEditor';

  // Profil
  static const String editProfile = 'editProfile';
  static const String userProfile = 'userProfile';

  // Arkadaşlar
  static const String friends = 'friends';
  static const String addFriend = 'addFriend';

  // Gruplar
  static const String groups = 'groups';
  static const String createGroup = 'createGroup';
  static const String groupDetail = 'groupDetail';

  // Diğer
  static const String trash = 'trash';
  static const String sharedNotes = 'sharedNotes';
  static const String search = 'search';
  static const String settings = 'settings';
  static const String changePassword = 'changePassword';

  // Hukuki
  static const String legal = 'legal';
  static const String privacyPolicy = 'privacyPolicy';
  static const String termsOfService = 'termsOfService';
}

/// Rota yol sabitleri
class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profileSetup = '/profile-setup';

  // Alt sekmeler (shell route altında)
  static const String home = '/home';
  static const String explore = '/explore';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Notlar
  static const String notesList = 'notes';
  static const String noteEditor = 'editor';
  static const String noteEditorWithId = 'editor/:noteId';

  // Profil
  static const String editProfile = 'edit';
  static const String userProfile = 'user/:userId';

  // Arkadaşlar
  static const String friends = 'friends';
  static const String addFriend = 'add-friend';

  // Gruplar
  static const String groups = 'groups';
  static const String createGroup = 'create-group';
  static const String groupDetail = 'group/:groupId';

  // Diğer
  static const String trash = 'trash';
  static const String sharedNotes = 'shared';
  static const String search = 'search';
  static const String settings = 'settings';
  static const String changePassword = 'change-password';

  // Hukuki
  static const String legal = 'legal';
  static const String privacyPolicy = 'privacy-policy';
  static const String termsOfService = 'terms-of-service';
}
