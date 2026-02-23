import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'theme_extensions.dart';

/// Uygulama teması tanımları — Light ve Dark mod
class AppTheme {
  AppTheme._();

  // ─────────────────── Light Theme ───────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      brightness: Brightness.light,
      primary: AppColors.primary500,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary900,
      secondary: AppColors.neutral600,
      onSecondary: AppColors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error500,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      floatingActionButtonTheme: _buildFabTheme(),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.light),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.light),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
      chipTheme: _buildChipTheme(Brightness.light),
      snackBarTheme: _buildSnackBarTheme(Brightness.light),
      dialogTheme: _buildDialogTheme(Brightness.light),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.light),
      extensions: [_lightAppColors, _lightNoteCardColors],
    );
  }

  // ─────────────────── Dark Theme ───────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      brightness: Brightness.dark,
      primary: AppColors.primary400,
      onPrimary: AppColors.primary900,
      primaryContainer: AppColors.primary800,
      onPrimaryContainer: AppColors.primary100,
      secondary: AppColors.neutral400,
      onSecondary: AppColors.neutral900,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error400,
      onError: AppColors.error100,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      floatingActionButtonTheme: _buildFabTheme(),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.dark),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.dark),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
      chipTheme: _buildChipTheme(Brightness.dark),
      snackBarTheme: _buildSnackBarTheme(Brightness.dark),
      dialogTheme: _buildDialogTheme(Brightness.dark),
      bottomSheetTheme: _buildBottomSheetTheme(Brightness.dark),
      extensions: [_darkAppColors, _darkNoteCardColors],
    );
  }

  // ─────────────────── Theme Extensions ───────────────────

  static const _lightAppColors = AppColorsExtension(
    primary: AppColors.primary500,
    primaryLight: AppColors.primary100,
    primaryDark: AppColors.primary700,
    background: AppColors.backgroundLight,
    surface: AppColors.surfaceLight,
    surfaceVariant: AppColors.surfaceVariantLight,
    card: AppColors.cardLight,
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textTertiary: AppColors.textTertiaryLight,
    textDisabled: AppColors.textDisabledLight,
    divider: AppColors.dividerLight,
    border: AppColors.borderLight,
    overlay: AppColors.overlayLight,
    shimmerBase: AppColors.shimmerBaseLight,
    shimmerHighlight: AppColors.shimmerHighlightLight,
    success: AppColors.success500,
    warning: AppColors.warning500,
    info: AppColors.info500,
  );

  static const _darkAppColors = AppColorsExtension(
    primary: AppColors.primary400,
    primaryLight: AppColors.primary800,
    primaryDark: AppColors.primary200,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceVariant: AppColors.surfaceVariantDark,
    card: AppColors.cardDark,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    textTertiary: AppColors.textTertiaryDark,
    textDisabled: AppColors.textDisabledDark,
    divider: AppColors.dividerDark,
    border: AppColors.borderDark,
    overlay: AppColors.overlayDark,
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
    success: AppColors.success400,
    warning: AppColors.warning400,
    info: AppColors.info400,
  );

  static const _lightNoteCardColors = NoteCardColorsExtension(
    colors: NoteCardColors.lightColors,
  );

  static const _darkNoteCardColors = NoteCardColorsExtension(
    colors: NoteCardColors.darkColors,
  );

  // ─────────────────── Text Theme ───────────────────

  static TextTheme _buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseColor =
        isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
    final secondaryColor =
        isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;

    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: baseColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: baseColor,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        titleLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: baseColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: baseColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: baseColor,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryColor,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: baseColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: secondaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: secondaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ─────────────────── AppBar Theme ───────────────────

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      backgroundColor:
          isLight ? AppColors.backgroundLight : AppColors.backgroundDark,
      foregroundColor:
          isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle:
          isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color:
            isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
      ),
    );
  }

  // ─────────────────── Card Theme ───────────────────

  static CardThemeData _buildCardTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return CardThemeData(
      elevation: isLight ? 0.5 : 0,
      color: isLight ? AppColors.cardLight : AppColors.cardDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
          width: 0.5,
        ),
      ),
      margin: EdgeInsets.zero,
    );
  }

  // ─────────────────── Button Themes ───────────────────

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary500,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary500,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─────────────────── Input Decoration ───────────────────

  static InputDecorationTheme _buildInputDecorationTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;
    final borderColor =
        isLight ? AppColors.borderLight : AppColors.borderDark;
    final fillColor =
        isLight ? AppColors.surfaceVariantLight : AppColors.surfaceVariantDark;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error500),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error500, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color:
            isLight ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isLight
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.error500,
      ),
    );
  }

  // ─────────────────── FAB Theme ───────────────────

  static FloatingActionButtonThemeData _buildFabTheme() {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary500,
      foregroundColor: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  // ─────────────────── Bottom Nav / NavigationBar ───────────────────

  static BottomNavigationBarThemeData _buildBottomNavTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;
    return BottomNavigationBarThemeData(
      backgroundColor:
          isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      selectedItemColor: AppColors.primary500,
      unselectedItemColor:
          isLight ? AppColors.neutral400 : AppColors.neutral500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;
    return NavigationBarThemeData(
      backgroundColor:
          isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      indicatorColor: AppColors.primary100,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ─────────────────── Chip Theme ───────────────────

  static ChipThemeData _buildChipTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ChipThemeData(
      backgroundColor: isLight
          ? AppColors.surfaceVariantLight
          : AppColors.surfaceVariantDark,
      selectedColor: AppColors.primary100,
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // ─────────────────── SnackBar Theme ───────────────────

  static SnackBarThemeData _buildSnackBarTheme(Brightness brightness) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ─────────────────── Dialog Theme ───────────────────

  static DialogThemeData _buildDialogTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return DialogThemeData(
      backgroundColor:
          isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color:
            isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
      ),
    );
  }

  // ─────────────────── BottomSheet Theme ───────────────────

  static BottomSheetThemeData _buildBottomSheetTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return BottomSheetThemeData(
      backgroundColor:
          isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true,
      dragHandleColor:
          isLight ? AppColors.neutral300 : AppColors.neutral600,
    );
  }
}
