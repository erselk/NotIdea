import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../theme/app_colors.dart';
import '../theme/theme_extensions.dart';

const _uuid = Uuid();

/// Benzersiz UUID oluşturur (v4)
String generateUniqueId() => _uuid.v4();

/// İsimden baş harfleri çıkarır. Örn: "Ali Veli" → "AV"
String getInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.isEmpty) return '';
  if (words.length == 1) {
    return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
  }
  return '${words.first[0]}${words.last[0]}'.toUpperCase();
}

/// Dosya boyutunu okunabilir formata çevirir.
/// Örn: 1536 → "1.5 KB", 1048576 → "1.0 MB"
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// Not kartı için rastgele renk seçer (ThemeExtension'dan)
Color getRandomNoteColor(BuildContext context) {
  final noteColors =
      Theme.of(context).extension<NoteCardColorsExtension>()!.colors;
  return noteColors[Random().nextInt(noteColors.length)];
}

/// Verilen index'e göre not kartı rengi döndürür (döngüsel)
Color getNoteColorByIndex(BuildContext context, int index) {
  final noteColors =
      Theme.of(context).extension<NoteCardColorsExtension>()!.colors;
  return noteColors[index % noteColors.length];
}

/// Not rengi hex'i (light palette) mevcut temaya göre Color'a çevirir.
/// Veritabanında light hex'ler saklandığı için dark modda doğru koyu rengi döndürür.
Color noteColorHexToThemeColor(BuildContext context, String? colorHex) {
  final hex = colorHex?.replaceFirst('#', '')?.toUpperCase();
  if (hex == null || hex.isEmpty) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }
  final hexWithHash = '#$hex';
  final index = NoteCardColors.lightColorHexes.indexOf(hexWithHash);
  if (index >= 0) {
    return Theme.of(context).extension<NoteCardColorsExtension>()!.colors[index];
  }
  try {
    return Color(int.parse('FF$hex', radix: 16));
  } catch (_) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }
}

/// Not kartı light mode renk listesinden index'e göre renk döndürür
/// (context gerektirmeyen versiyon — doğrudan AppColors kullanır)
Color getNoteColorByIndexStatic(int index, {bool isDark = false}) {
  final colors =
      isDark ? NoteCardColors.darkColors : NoteCardColors.lightColors;
  return colors[index % colors.length];
}

/// İki renk arasında kontrast oranını hesaplar
/// Metin rengini belirlemede kullanılır (açık/koyu arka plan)
Color getContrastTextColor(Color backgroundColor) {
  final luminance = backgroundColor.computeLuminance();
  return luminance > 0.5 ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
}
