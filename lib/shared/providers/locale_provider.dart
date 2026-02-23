import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/l10n/l10n.dart';

part 'locale_provider.g.dart';

const _localeKey = 'app_locale';

/// Dil (locale) yönetimi.
/// Cihaz dilini otomatik algılar, kullanıcı tercihi güvenli depolamada saklanır.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  final _storage = const FlutterSecureStorage();

  @override
  Locale build() {
    _loadSavedLocale();
    return _getDeviceLocale();
  }

  /// Cihaz dilini algılayarak desteklenen bir locale döndürür
  Locale _getDeviceLocale() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final resolved = L10n.localeResolutionCallback(
      deviceLocale,
      L10n.supportedLocales,
    );
    return resolved ?? L10n.defaultLocale;
  }

  Future<void> _loadSavedLocale() async {
    final saved = await _storage.read(key: _localeKey);
    if (saved != null) {
      final savedLocale = Locale(saved);
      if (L10n.supportedLocales.any(
        (l) => l.languageCode == savedLocale.languageCode,
      )) {
        state = savedLocale;
      }
    }
  }

  /// Dili değiştirir ve tercihi saklar
  Future<void> setLocale(Locale locale) async {
    if (!L10n.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    )) {
      return;
    }
    state = locale;
    await _storage.write(key: _localeKey, value: locale.languageCode);
  }

  /// Türkçe ↔ İngilizce arasında geçiş yapar
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'tr'
        ? const Locale('en')
        : const Locale('tr');
    await setLocale(newLocale);
  }
}
