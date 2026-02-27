import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/l10n/app_localizations.dart';

/// Form doğrulama fonksiyonları
class Validators {
  Validators._();

  /// E-posta doğrulama
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.emailInvalid;
    }
    return null;
  }

  /// Şifre doğrulama: min 8 karakter, büyük harf, küçük harf, rakam
  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return l10n.passwordTooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n.passwordLowercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.passwordDigit;
    }
    return null;
  }

  /// Şifre onay doğrulaması
  static String? confirmPassword(String? value, String password, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  /// Kullanıcı adı: alfanümerik, 3-20 karakter
  static String? username(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.usernameRequired;
    }
    final trimmed = value.trim();
    if (trimmed.length < AppConstants.minUsernameLength) {
      return l10n.usernameTooShort;
    }
    if (trimmed.length > AppConstants.maxUsernameLength) {
      return l10n.usernameTooLong;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return l10n.usernameInvalid;
    }
    return null;
  }

  /// Görünen ad doğrulama
  static String? displayName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.displayNameRequired;
    }
    if (value.trim().length > AppConstants.maxDisplayNameLength) {
      return l10n.displayNameTooLong;
    }
    return null;
  }

  /// Not başlığı doğrulama
  static String? noteTitle(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }
    if (value.trim().length > AppConstants.maxNoteTitleLength) {
      return l10n.required;
    }
    return null;
  }

  /// Genel boş alan kontrolü
  static String? required(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }
    return null;
  }
}

