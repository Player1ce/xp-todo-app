// lib/theme/app_theme.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── COLOR TOKENS ───────────────────────────────────────────────

class AppColors {
  // Dark backgrounds
  static const bgPrimaryDark = Color(0xFF0E1117);
  static const bgSecondaryDark = Color(0xFF161B27);
  static const bgCardDark = Color(0xFF1A2035);
  static const bgElevatedDark = Color(0xFF1E2640);

  // Light backgrounds
  static const bgPrimaryLight = Color(0xFFF0F2F7);
  static const bgSecondaryLight = Color(0xFFFFFFFF);
  static const bgCardLight = Color(0xFFFFFFFF);
  static const bgElevatedLight = Color(0xFFE8ECF5);

  // Borders
  static const borderDark = Color(0xFF2A3550);
  static const borderBrightDark = Color(0xFF3A4F70);
  static const borderLight = Color(0xFFD0D8E8);
  static const borderBrightLight = Color(0xFFB0BCD8);

  // Accents — same across light/dark for brand consistency
  static const accentBlue = Color(0xFF4D9FFF);
  static const accentBlueDark = Color(0xFF2D6ABF);
  static const accentBlueDarker = Color(0xFF1A4A9F);
  static const accentGold = Color(0xFFF0A040); // XP only
  static const accentGoldDark = Color(0xFFA06820);
  static const accentGreen = Color(0xFF4CAF80);
  static const accentRed = Color(0xFFE05050);
  static const sideQuest = Color(0xFF8060C0);
  static const mainStory = Color(0xFF4D9FFF);

  // Text — dark theme
  static const textPrimaryDark = Color(0xFFE8EAF2);
  static const textSecondaryDark = Color(0xFF8A9BC0);
  static const textDimDark = Color(0xFF4A5878);

  // Text — light theme
  static const textPrimaryLight = Color(0xFF1A2040);
  static const textSecondaryLight = Color(0xFF5A6888);
  static const textDimLight = Color(0xFFA0AABE);

  // ─── BRIGHTNESS-AWARE HELPERS ───────────────────────────────
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bgPrimary(BuildContext context) =>
      _isDark(context) ? bgPrimaryDark : bgPrimaryLight;

  static Color bgSecondary(BuildContext context) =>
      _isDark(context) ? bgSecondaryDark : bgSecondaryLight;

  static Color bgCard(BuildContext context) =>
      _isDark(context) ? bgCardDark : bgCardLight;

  static Color bgElevated(BuildContext context) =>
      _isDark(context) ? bgElevatedDark : bgElevatedLight;

  static Color border(BuildContext context) =>
      _isDark(context) ? borderDark : borderLight;

  static Color borderBright(BuildContext context) =>
      _isDark(context) ? borderBrightDark : borderBrightLight;

  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? textSecondaryDark : textSecondaryLight;

  static Color textDim(BuildContext context) =>
      _isDark(context) ? textDimDark : textDimLight;
}

// ─── TEXT STYLES ────────────────────────────────────────────────

class AppTextStyles {
  static const screenTitleDark = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.textPrimaryDark,
  );

  static const screenTitleLight = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.textPrimaryLight,
  );

  static const sectionHeaderDark = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.accentBlue,
  );

  static const sectionHeaderLight = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.accentBlueDarker,
  );

  static const tag = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 8,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static const navLabel = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static const bodyDark = TextStyle(
    fontFamily: 'ExoTwo',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
  );

  static const bodyLight = TextStyle(
    fontFamily: 'ExoTwo',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static const bodySmallDark = TextStyle(
    fontFamily: 'ExoTwo',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryDark,
  );

  static const bodySmallLight = TextStyle(
    fontFamily: 'ExoTwo',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
  );

  static const xpValue = TextStyle(
    fontFamily: 'ShareTechMono',
    fontSize: 13,
    color: AppColors.accentGold,
  );

  static const statValueDark = TextStyle(
    fontFamily: 'ShareTechMono',
    fontSize: 13,
    color: AppColors.textPrimaryDark,
  );

  static const statValueLight = TextStyle(
    fontFamily: 'ShareTechMono',
    fontSize: 13,
    color: AppColors.textPrimaryLight,
  );
}

// ─── MATERIAL THEMES ────────────────────────────────────────────

class AppMaterialTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimaryDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentBlue,
      primaryContainer: AppColors.accentBlueDark,
      secondary: AppColors.accentGold,
      surface: AppColors.bgCardDark,
      error: AppColors.accentRed,
      onPrimary: Colors.white,
      onSecondary: AppColors.bgPrimaryDark,
      onSurface: AppColors.textPrimaryDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSecondaryDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.screenTitleDark,
      iconTheme: IconThemeData(color: AppColors.textSecondaryDark),
      shape: Border(bottom: BorderSide(color: AppColors.borderDark, width: 1)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgSecondaryDark,
      selectedItemColor: AppColors.accentBlue,
      unselectedItemColor: AppColors.textDimDark,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    cardTheme: CardThemeData(
      color: AppColors.bgCardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgCardDark,
      hintStyle: AppTextStyles.bodySmallDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.accentBlue),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentGreen;
        }
        return Colors.transparent;
      }),
      side: const BorderSide(color: AppColors.borderBrightDark, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.textDimDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentBlue;
        }
        return AppColors.borderBrightDark;
      }),
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: AppColors.bgCardDark,
      iconColor: AppColors.textSecondaryDark,
      titleTextStyle: AppTextStyles.bodyDark,
      subtitleTextStyle: AppTextStyles.bodySmallDark,
    ),

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.screenTitleDark,
      bodyLarge: AppTextStyles.bodyDark,
      bodySmall: AppTextStyles.bodySmallDark,
      labelSmall: AppTextStyles.tag,
    ),
  );

  // ─── MATERIAL LIGHT ───────────────────────────────────────────

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgPrimaryLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.accentBlue,
      primaryContainer: AppColors.accentBlueDarker,
      secondary: AppColors.accentGold,
      surface: AppColors.bgCardLight,
      error: AppColors.accentRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSecondaryLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.screenTitleLight,
      iconTheme: IconThemeData(color: AppColors.textSecondaryLight),
      shape: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgSecondaryLight,
      selectedItemColor: AppColors.accentBlue,
      unselectedItemColor: AppColors.textDimLight,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    cardTheme: CardThemeData(
      color: AppColors.bgCardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
      space: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgCardLight,
      hintStyle: AppTextStyles.bodySmallLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.accentBlue),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentGreen;
        }
        return Colors.transparent;
      }),
      side: const BorderSide(color: AppColors.borderBrightLight, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.textDimLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentBlue;
        }
        return AppColors.borderBrightLight;
      }),
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: AppColors.bgCardLight,
      iconColor: AppColors.textSecondaryLight,
      titleTextStyle: AppTextStyles.bodyLight,
      subtitleTextStyle: AppTextStyles.bodySmallLight,
    ),

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.screenTitleLight,
      bodyLarge: AppTextStyles.bodyLight,
      bodySmall: AppTextStyles.bodySmallLight,
      labelSmall: AppTextStyles.tag,
    ),
  );
}

// ─── CUPERTINO THEMES ───────────────────────────────────────────
//
// CupertinoThemeData has fewer slots than Material. Things like
// card colors and dividers are set at the widget level using
// AppColors directly rather than via the theme.

class AppCupertinoTheme {
  static CupertinoThemeData get dark => const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accentBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: AppColors.bgPrimaryDark,
    barBackgroundColor: AppColors.bgSecondaryDark,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.accentBlue,
      textStyle: AppTextStyles.bodyDark,
      actionTextStyle: TextStyle(
        fontFamily: 'ExoTwo',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.accentBlue,
      ),
      tabLabelTextStyle: AppTextStyles.navLabel,
      navTitleTextStyle: AppTextStyles.screenTitleDark,
      navLargeTitleTextStyle: TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: AppColors.textPrimaryDark,
      ),
      navActionTextStyle: TextStyle(
        fontFamily: 'ExoTwo',
        fontSize: 13,
        color: AppColors.accentBlue,
      ),
    ),
  );

  static CupertinoThemeData get light => const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.accentBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: AppColors.bgPrimaryLight,
    barBackgroundColor: AppColors.bgSecondaryLight,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.accentBlue,
      textStyle: AppTextStyles.bodyLight,
      actionTextStyle: TextStyle(
        fontFamily: 'ExoTwo',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.accentBlue,
      ),
      tabLabelTextStyle: AppTextStyles.navLabel,
      navTitleTextStyle: AppTextStyles.screenTitleLight,
      navLargeTitleTextStyle: TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: AppColors.textPrimaryLight,
      ),
      navActionTextStyle: TextStyle(
        fontFamily: 'ExoTwo',
        fontSize: 13,
        color: AppColors.accentBlue,
      ),
    ),
  );
}
