/// Supabase storage bucket isimleri ve yol sabitleri
class StorageConstants {
  StorageConstants._();

  // Bucket isimleri
  static const String avatarsBucket = 'avatars';
  static const String noteImagesBucket = 'note-images';

  // Yol şablonları
  static String avatarPath(String userId) => '$userId/avatar';
  static String noteImagePath(String userId, String noteId, String fileName) =>
      '$userId/$noteId/$fileName';

  // İzin verilen MIME türleri
  static const List<String> allowedImageMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ];

  // Cache süreleri (saniye)
  static const int imageCacheDuration = 60 * 60 * 24 * 7; // 7 gün
}
