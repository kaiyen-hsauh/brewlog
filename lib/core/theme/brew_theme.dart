import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// §9.2 設計系統色彩 token
/// 原創配色,不可抄 SCA 風味輪。
class BrewColors {
  BrewColors._();

  static const Color primary = Color(0xFF6F4E37); // 咖啡棕
  static const Color secondary = Color(0xFFC8A27A); // 拿鐵奶褐
  static const Color accent = Color(0xFFD97706); // 琥珀橙
  static const Color success = Color(0xFF047857);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFB91C1C);
  static const Color surface = Color(0xFFFAF7F2); // 米白
  static const Color onSurface = Color(0xFF1F2937);
}

/// §9.3 字級
/// 最小字級不得小於 12sp (§9.5 強制)。
class BrewTypography {
  BrewTypography._();

  static const double timer = 64; // 計時器數字 §F2.1
  static const double pageTitle = 24; // 頁面標題
  static const double sectionTitle = 18; // 區塊標題
  static const double body = 16; // 內文
  static const double caption = 14; // 次要說明
  static const double minReadable = 12; // 不可小於此值
}

/// §9.2 Material 3 主題(MUST)
ThemeData buildBrewTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: BrewColors.primary,
    brightness: Brightness.light,
    primary: BrewColors.primary,
    secondary: BrewColors.secondary,
    tertiary: BrewColors.accent,
    surface: BrewColors.surface,
    error: BrewColors.error,
    onPrimary: Colors.white,
    onSecondary: BrewColors.onSurface,
    onSurface: BrewColors.onSurface,
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true, // §9.2 MUST
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BrewColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: BrewColors.surface,
      foregroundColor: BrewColors.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.timer,
        fontWeight: FontWeight.bold,
        color: BrewColors.onSurface,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineMedium: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.pageTitle,
        fontWeight: FontWeight.bold,
        color: BrewColors.onSurface,
      ),
      titleLarge: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.sectionTitle,
        fontWeight: FontWeight.w600,
        color: BrewColors.onSurface,
      ),
      bodyLarge: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.body,
        color: BrewColors.onSurface,
      ),
      bodyMedium: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.body,
        color: BrewColors.onSurface,
      ),
      bodySmall: GoogleFonts.notoSansTc(
        fontSize: BrewTypography.caption,
        color: BrewColors.onSurface,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56), // §S1 CTA
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: BrewColors.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: BrewColors.primary, width: 2),
      ),
    ),
  );
}
