import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';

/// Desteklenen diller ve lokalizasyon yardımcıları
class L10n {
  L10n._();

  /// Desteklenen diller listesi
  static const supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  /// Varsayılan dil
  static const defaultLocale = Locale('en');

  /// Cihaz diline göre locale çözümleme
  static Locale? localeResolutionCallback(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    if (deviceLocale == null) return defaultLocale;

    for (final locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode) {
        return locale;
      }
    }

    return defaultLocale;
  }

  /// AppLocalizations'a kısayol erişim
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Locale kodundan görünen isim döndürür
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
}
