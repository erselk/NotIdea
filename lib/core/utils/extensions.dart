import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../theme/theme_extensions.dart';

// ─────────────────── BuildContext Uzantıları ───────────────────

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppColorsExtension get appColors =>
      theme.extension<AppColorsExtension>()!;

  NoteCardColorsExtension get noteCardColors =>
      theme.extension<NoteCardColorsExtension>()!;

  Brightness get brightness => theme.brightness;

  bool get isDarkMode => brightness == Brightness.dark;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}

// ─────────────────── String Uzantıları ───────────────────

extension StringX on String {
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  bool get isNotBlank => trim().isNotEmpty;

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }
}

// ─────────────────── DateTime Uzantıları ───────────────────

extension DateTimeX on DateTime {
  /// "2 saat önce", "3 gün önce" gibi göreceli zaman formatı
  String get timeAgo => timeago.format(this, locale: 'tr');

  /// "2 saat önce" — İngilizce
  String get timeAgoEn => timeago.format(this, locale: 'en');

  /// "23 Şub 2026" formatı
  String get formattedDate => DateFormat('d MMM yyyy', 'tr_TR').format(this);

  /// "23 Şub 2026 14:30" formatı
  String get formattedDateTime =>
      DateFormat('d MMM yyyy HH:mm', 'tr_TR').format(this);

  /// "14:30" formatı
  String get formattedTime => DateFormat('HH:mm', 'tr_TR').format(this);

  /// Bugün mü kontrolü
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Dün mü kontrolü
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Bu hafta mı kontrolü
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return isAfter(startOfWeek.subtract(const Duration(days: 1)));
  }
}

// ─────────────────── Nullable Uzantıları ───────────────────

extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
}
