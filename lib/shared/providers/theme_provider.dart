import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/core/database/app_database.dart';

part 'theme_provider.g.dart';

const _themeKey = 'theme_mode';

/// Tema modu (light/dark/system) yönetimi.
/// AppDatabase.instance (Hive) ile senkron okuma —
/// main() içinde AppDatabase.init() beklendiğinden flash olmaz.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final saved = AppDatabase.instance.getPref<String>(_themeKey);
    if (saved != null) {
      return ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await AppDatabase.instance.setPref(_themeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
