import 'package:flutter/material.dart';

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

/// §9.3 字級 + bundled Noto Sans TC(assets/fonts/),離線 / CI 也完整 render CJK。
class BrewTypography {
  BrewTypography._();

  static const String fontFamily = 'NotoSansTC';
  static const double timer = 64; // 計時器數字 §F2.1
  static const double pageTitle = 24; // 頁面標題
  static const double sectionTitle = 18; // 區塊標題
  static const double body = 16; // 內文
  static const double caption = 14; // 次要說明
  static const double minReadable = 12; // 不可小於此值
}

TextStyle _ntc(double size, FontWeight weight, Color color, {List<FontFeature>? features}) {
  return TextStyle(
    fontFamily: BrewTypography.fontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
    fontFeatures: features,
  );
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
    fontFamily: BrewTypography.fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BrewColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: BrewColors.surface,
      foregroundColor: BrewColors.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: TextTheme(
      displayLarge: _ntc(BrewTypography.timer, FontWeight.bold, BrewColors.onSurface, features: const [FontFeature.tabularFigures()]),
      headlineMedium: _ntc(BrewTypography.pageTitle, FontWeight.bold, BrewColors.onSurface),
      titleLarge: _ntc(BrewTypography.sectionTitle, FontWeight.w600, BrewColors.onSurface),
      bodyLarge: _ntc(BrewTypography.body, FontWeight.normal, BrewColors.onSurface),
      bodyMedium: _ntc(BrewTypography.body, FontWeight.normal, BrewColors.onSurface),
      bodySmall: _ntc(BrewTypography.caption, FontWeight.normal, BrewColors.onSurface),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56), // §S1 CTA
        textStyle: _ntc(17, FontWeight.w600, Colors.white),
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
