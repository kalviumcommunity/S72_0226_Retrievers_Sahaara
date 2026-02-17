import 'package:flutter/material.dart';

/// AppTheme - Design system colors, text styles, and spacing
class AppTheme {
  AppTheme._();

  // ============ COLORS ============

  /// Primary Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  /// Secondary Colors
  static const Color secondaryColor = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);

  /// Accent Colors
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFCD34D);
  static const Color accentDark = Color(0xFFD97706);

  /// Semantic Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  /// Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  /// Background Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFAFAFA);

  /// Border Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color borderLightColor = Color(0xFFF3F4F6);

  // ============ TEXT STYLES ============

  /// Heading Styles
  static const TextStyle headingXXL = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: black,
  );

  static const TextStyle headingXL = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.25,
    letterSpacing: -0.3,
    color: black,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
    letterSpacing: -0.2,
    color: black,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.33,
    letterSpacing: 0,
    color: black,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.4,
    letterSpacing: 0,
    color: black,
  );

  /// Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: gray900,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: gray900,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: gray700,
  );

  static const TextStyle bodyExtraSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: gray600,
  );

  /// Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
    letterSpacing: 0.15,
    color: gray900,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 1.43,
    letterSpacing: 0.1,
    color: gray800,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    height: 1.33,
    letterSpacing: 0.5,
    color: gray700,
  );

  /// Caption Styles
  static const TextStyle captionLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0,
    color: gray600,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.4,
    color: gray500,
  );

  // ============ SPACING ============

  /// Spacing Scale (8pt base unit)
  static const double spacing0 = 0;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing28 = 28;
  static const double spacing32 = 32;
  static const double spacing36 = 36;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;

  /// Common Spacing Sizes
  static const double paddingExtraSmall = spacing8;
  static const double paddingSmall = spacing12;
  static const double paddingMedium = spacing16;
  static const double paddingLarge = spacing24;
  static const double paddingExtraLarge = spacing32;

  // ============ BORDER RADIUS ============

  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusExtraLarge = 24;
  static const double radiusFull = 999;

  /// Border Radius Values
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusExtraLarge = BorderRadius.all(Radius.circular(radiusExtraLarge));

  // ============ SHADOW ============

  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x19000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow shadowExtraLarge = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  static List<BoxShadow> shadowElevationSmall = [shadowSmall];
  static List<BoxShadow> shadowElevationMedium = [shadowMedium];
  static List<BoxShadow> shadowElevationLarge = [shadowLarge];
  static List<BoxShadow> shadowElevationExtraLarge = [shadowExtraLarge];

  // ============ THEME DATA ============

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingSmall,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusLarge,
          ),
          textStyle: labelMedium.copyWith(color: white),
          elevation: 0,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusLarge,
          ),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingMedium,
            vertical: paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusLarge,
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMedium,
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: bodySmall.copyWith(color: gray400),
        labelStyle: bodyMedium.copyWith(color: gray700),
        errorStyle: captionSmall.copyWith(color: errorColor),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: headingXXL,
        displayMedium: headingXL,
        displaySmall: headingLarge,
        headlineLarge: headingMedium,
        headlineMedium: headingSmall,
        headlineSmall: bodyLarge,
        titleLarge: labelLarge,
        titleMedium: labelMedium,
        titleSmall: labelSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: gray700,
        size: 24,
      ),
      
      primaryIconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: gray100,
        selectedColor: primaryColor,
        disabledColor: gray200,
        padding: const EdgeInsets.symmetric(
          horizontal: paddingSmall,
          vertical: paddingExtraSmall,
        ),
        labelStyle: bodySmall,
        secondaryLabelStyle: bodySmall.copyWith(color: white),
        shape: StadiumBorder(
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
        ),
        elevation: 8,
        backgroundColor: surfaceColor,
        titleTextStyle: headingSmall,
        contentTextStyle: bodyMedium,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        secondary: secondaryLight,
        tertiary: accentColor,
        error: errorColor,
        surface: gray900,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: gray900,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: gray800,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingSmall,
      ),
      
      cardTheme: CardThemeData(
        color: gray800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMedium,
          side: const BorderSide(color: gray700, width: 1),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray800,
        border: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: gray700, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: gray700, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
      ),
    );
  }
}
