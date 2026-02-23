import 'package:flutter/material.dart';

/// Not kartları arka plan renkleri için ThemeExtension.
/// Light ve dark modda farklı renk listeleri döndürür.
class NoteCardColorsExtension extends ThemeExtension<NoteCardColorsExtension> {
  const NoteCardColorsExtension({required this.colors});

  final List<Color> colors;

  @override
  NoteCardColorsExtension copyWith({List<Color>? colors}) {
    return NoteCardColorsExtension(colors: colors ?? this.colors);
  }

  @override
  NoteCardColorsExtension lerp(
    covariant NoteCardColorsExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return NoteCardColorsExtension(
      colors: List.generate(
        colors.length,
        (i) => Color.lerp(colors[i], other.colors[i], t) ?? colors[i],
      ),
    );
  }
}

/// Uygulama genelindeki özel renkler için ThemeExtension.
/// Brand, yüzey, metin ve anlamsal renkleri içerir.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.divider,
    required this.border,
    required this.overlay,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color divider;
  final Color border;
  final Color overlay;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color success;
  final Color warning;
  final Color info;

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? divider,
    Color? border,
    Color? overlay,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      overlay: overlay ?? this.overlay,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColorsExtension lerp(covariant AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
