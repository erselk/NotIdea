/// Form doğrulama fonksiyonları
class Validators {
  Validators._();

  /// E-posta doğrulama
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi gereklidir';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  /// Şifre doğrulama: min 8 karakter, büyük harf, küçük harf, rakam
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gereklidir';
    }
    if (value.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Şifre en az bir büyük harf içermelidir';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Şifre en az bir küçük harf içermelidir';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Şifre en az bir rakam içermelidir';
    }
    return null;
  }

  /// Şifre onay doğrulaması
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Şifre onayı gereklidir';
    }
    if (value != password) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  /// Kullanıcı adı: alfanümerik, 3-20 karakter
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kullanıcı adı gereklidir';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Kullanıcı adı en az 3 karakter olmalıdır';
    }
    if (trimmed.length > 20) {
      return 'Kullanıcı adı en fazla 20 karakter olabilir';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return 'Kullanıcı adı yalnızca harf, rakam ve alt çizgi içerebilir';
    }
    return null;
  }

  /// Görünen ad doğrulama
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Görünen ad gereklidir';
    }
    if (value.trim().length > 50) {
      return 'Görünen ad en fazla 50 karakter olabilir';
    }
    return null;
  }

  /// Not başlığı doğrulama
  static String? noteTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not başlığı gereklidir';
    }
    if (value.trim().length > 200) {
      return 'Not başlığı en fazla 200 karakter olabilir';
    }
    return null;
  }

  /// Genel boş alan kontrolü
  static String? required(String? value, [String fieldName = 'Bu alan']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName gereklidir';
    }
    return null;
  }

  /// Genel uzunluk kontrolü
  static String? maxLength(String? value, int max, [String fieldName = 'Bu alan']) {
    if (value != null && value.length > max) {
      return '$fieldName en fazla $max karakter olabilir';
    }
    return null;
  }
}
