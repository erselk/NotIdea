/// Uygulama genelinde kullanılan sabit değerler
class AppConstants {
  AppConstants._();

  // Uygulama bilgileri
  static const String appName = 'NotIdea';
  static const String appTagline = 'Your creative note-taking companion';
  static const String appVersion = '2.0.0';

  // Supabase auth callback deep link URL
  static const String authRedirectUrl = 'notidea://callback';
  
  // Link Paylaşımı için Base URL
  // Domain hazır olduğunda burayı 'https://notidea.ersel.dev' ile değiştirebilirsiniz.
  // Geliştirme aşamasında Vercel preview URL'ini veya localhost kullanabilirsiniz.
  static const String baseUrl = 'https://notidea.ersel.dev';

  // Sayfalama limitleri
  static const int defaultPageSize = 20;
  static const int notesPageSize = 20;
  static const int explorePageSize = 30;
  static const int friendsPageSize = 25;
  static const int searchResultsLimit = 50;

  // Medya kısıtlamaları
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;
  static const int imageQuality = 80;
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];

  // Not başlık ve içerik kısıtlamaları
  static const int maxNoteTitleLength = 200;
  static const int maxNoteContentLength = 50000;
  static const int maxGroupNameLength = 100;
  static const int maxBioLength = 300;
  static const int maxDisplayNameLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 8;

  // Avatar
  static const double avatarSizeSmall = 32;
  static const double avatarSizeMedium = 48;
  static const double avatarSizeLarge = 80;
  static const double avatarSizeXLarge = 120;

  // Animasyon süreleri
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
}
