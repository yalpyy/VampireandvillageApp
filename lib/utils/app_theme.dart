import 'package:flutter/material.dart';

class AppTheme {
  // ── Gothic fantasy palette ──
  static const Color primaryRed = Color(0xFFE94560);
  static const Color darkPurple = Color(0xFF4A148C);
  static const Color darkBlue = Color(0xFF1A1040);
  static const Color darkBg = Color(0xFF0D0816);
  static const Color darkerBg = Color(0xFF08040F);
  static const Color cardBg = Color(0xFF1E1233);
  static const Color surfaceBg = Color(0xFF251742);

  // Gold accents
  static const Color goldPrimary = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color goldDark = Color(0xFF8B6914);
  static const Color crimson = Color(0xFFB91C1C);

  // Spacing
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 20.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  // Radius
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 100.0;

  // Button height
  static const double buttonHeight = 56.0;
  static const double buttonHeightLg = 64.0;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        secondary: darkPurple,
        surface: cardBg,
        error: Colors.redAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A0E2E),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: goldLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        iconTheme: IconThemeData(color: goldLight),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: goldPrimary.withOpacity(0.15)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: crimson,
          foregroundColor: goldLight,
          elevation: 4,
          shadowColor: crimson.withOpacity(0.4),
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            side: BorderSide(color: goldPrimary.withOpacity(0.3)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldLight,
          side: BorderSide(color: goldPrimary.withOpacity(0.4)),
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: goldPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: goldPrimary.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: goldPrimary.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: goldPrimary.withOpacity(0.6), width: 2),
        ),
        hintStyle: TextStyle(color: goldLight.withOpacity(0.3)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceBg,
        selectedColor: crimson,
        labelStyle: const TextStyle(color: goldLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: spacingSm, vertical: spacingXs),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(radiusLg)),
          side: BorderSide(color: goldPrimary.withOpacity(0.2)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: goldPrimary.withOpacity(0.2)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return goldPrimary;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return goldDark.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: goldLight,
        iconColor: goldPrimary,
      ),
    );
  }

  // Gradient overlays
  static LinearGradient get darkOverlay => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.6),
          Colors.black.withOpacity(0.8),
        ],
      );

  static LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [surfaceBg, darkBlue],
      );

  static BoxDecoration get premiumCardDecoration => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [crimson, Color(0xFF7F1D1D)],
        ),
        borderRadius: BorderRadius.circular(radiusMd),
        border: Border.all(color: goldPrimary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: crimson.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      );
}
