import 'dart:ui';

/// Uygulama genelinde kullanılan tüm renkler.
/// Tailwind CSS renk skalalarına dayalıdır.
/// Asla satır içi hex/rgb kullanmayın — tüm renkler buradan gelmelidir.
class AppColors {
  AppColors._();

  // ─── Brand (Primary) ─── Yeşil tonları (#06A74D bazlı) ───
  static const Color primary50 = Color(0xFFECFDF3);
  static const Color primary100 = Color(0xFFD1FAE0);
  static const Color primary200 = Color(0xFFA6F4C5);
  static const Color primary300 = Color(0xFF6CE9A0);
  static const Color primary400 = Color(0xFF34D374);
  static const Color primary500 = Color(0xFF06A74D);
  static const Color primary600 = Color(0xFF058A40);
  static const Color primary700 = Color(0xFF046D35);
  static const Color primary800 = Color(0xFF03562A);
  static const Color primary900 = Color(0xFF024522);

  // ─── Neutral / Gray (Tailwind slate) ───
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);
  static const Color neutral950 = Color(0xFF020617);

  // ─── Surface / Background ───
  static const Color backgroundLight = Color(0xFFFCFBFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantLight = Color(0xFFF5F5F4);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF252525);

  // ─── Text ───
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color textDisabledLight = Color(0xFFCBD5E1);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color textDisabledDark = Color(0xFF475569);

  // ─── Semantic — Error (Tailwind red) ───
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error400 = Color(0xFFF87171);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);

  // ─── Semantic — Success (Tailwind emerald) ───
  static const Color success50 = Color(0xFFECFDF5);
  static const Color success100 = Color(0xFFD1FAE5);
  static const Color success400 = Color(0xFF34D399);
  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success700 = Color(0xFF047857);

  // ─── Semantic — Warning (Tailwind amber) ───
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);

  // ─── Semantic — Info (Tailwind sky) ───
  static const Color info50 = Color(0xFFF0F9FF);
  static const Color info100 = Color(0xFFE0F2FE);
  static const Color info400 = Color(0xFF38BDF8);
  static const Color info500 = Color(0xFF0EA5E9);
  static const Color info600 = Color(0xFF0284C7);
  static const Color info700 = Color(0xFF0369A1);

  // ─── Divider / Border ───
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color borderDark = Color(0xFF475569);

  // ─── Overlay ───
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayDark = Color(0x66000000);

  // ─── Shimmer ───
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF1F5F9);
  static const Color shimmerBaseDark = Color(0xFF334155);
  static const Color shimmerHighlightDark = Color(0xFF475569);

  // ─── White & Black ───
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

/// Not kartları için arka plan renkleri.
/// Her rengin light ve dark varyantı bulunur.
class NoteCardColors {
  NoteCardColors._();

  // ─── Light mode not kartı renkleri ───
  static const Color c1Light = Color(0xFFE5EAE4);
  static const Color c2Light = Color(0xFFF7EF81);
  static const Color c3Light = Color(0xFFD9ED92);
  static const Color c4Light = Color(0xFF79B669);
  static const Color c5Light = Color(0xFFFFDCE0);
  static const Color c6Light = Color(0xFFCDB4DB);
  static const Color c7Light = Color(0xFF613F75);
  static const Color c8Light = Color(0xFF77A6B6);
  static const Color c9Light = Color(0xFF1A759F);

  // ─── Dark mode not kartı renkleri (koyu/mat versiyonlar) ───
  static const Color c1Dark = Color(0xFF2B332B);
  static const Color c2Dark = Color(0xFF4A4513);
  static const Color c3Dark = Color(0xFF384013);
  static const Color c4Dark = Color(0xFF223A1B);
  static const Color c5Dark = Color(0xFF52282E);
  static const Color c6Dark = Color(0xFF3B2D42);
  static const Color c7Dark = Color(0xFF2F1D3A);
  static const Color c8Dark = Color(0xFF233B43);
  static const Color c9Dark = Color(0xFF0C384F);

  /// Light modda kullanılacak not kartı renk listesi
  static const List<Color> lightColors = [
    c1Light,
    c2Light,
    c3Light,
    c4Light,
    c5Light,
    c6Light,
    c7Light,
    c8Light,
    c9Light,
  ];

  /// Dark modda kullanılacak not kartı renk listesi
  static const List<Color> darkColors = [
    c1Dark,
    c2Dark,
    c3Dark,
    c4Dark,
    c5Dark,
    c6Dark,
    c7Dark,
    c8Dark,
    c9Dark,
  ];

  /// Veritabanına kaydedilecek orijinal (light) hex kodları
  static const List<String> lightColorHexes = [
    '#E5EAE4',
    '#F7EF81',
    '#D9ED92',
    '#79B669',
    '#FFDCE0',
    '#CDB4DB',
    '#613F75',
    '#77A6B6',
    '#1A759F',
  ];
}
