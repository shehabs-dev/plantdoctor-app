import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_sizes.dart';
import 'app_text_theme.dart';

/// App theme.
/// - Colors come from AppColors → ColorScheme → all widgets
/// - Fonts come from AppFonts.primaryFamily / monoFamily (const strings)
/// - Sizes come from AppSizes raw constants (no ScreenUtil)
/// - Text styles come from AppTextTheme
///
/// ⚠️  Only raw constants are used here — no ScreenUtil dependency.
///     Responsive sizing belongs in the widget layer only.
///
/// To change the app color:  update AppColors → changes everywhere ✅
/// To change a font:         update AppFonts  → changes everywhere ✅
/// To change a size:         update AppSizes raw constants → changes everywhere ✅

class AppTheme {
  AppTheme._();

  // ════════════════════════════════════════════════
  // COLOR SCHEMES — single source of truth
  // ════════════════════════════════════════════════

  static const ColorScheme _darkScheme = ColorScheme.dark(
    surface: AppColors.surface,
    primary: AppColors.greenDark,
    primaryContainer: AppColors.greenDimDark,
    secondary: AppColors.amberDark,
    secondaryContainer: AppColors.amberDimDark,
    tertiary: AppColors.blueDark,
    tertiaryContainer: AppColors.blueDimDark,
    error: AppColors.redDark,
    errorContainer: AppColors.redDimDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
    outline: AppColors.border,
    outlineVariant: AppColors.borderSoft,
    surfaceContainerHighest: AppColors.surface2,
  );

  static const ColorScheme _lightScheme = ColorScheme.light(
    surface: AppColors.lightSurface,
    primary: AppColors.green,
    primaryContainer: AppColors.greenDim,
    secondary: AppColors.amber,
    secondaryContainer: AppColors.amberDim,
    tertiary: AppColors.blue,
    tertiaryContainer: AppColors.blueDim,
    error: AppColors.red,
    errorContainer: AppColors.redDim,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.lightTextPrimary,
    onError: Colors.white,
    outline: AppColors.lightBorder,
    outlineVariant: AppColors.lightBorderSoft,
    surfaceContainerHighest: AppColors.lightSurface2,
  );

  // ════════════════════════════════════════════════
  // PUBLIC GETTERS
  // ════════════════════════════════════════════════

  static ThemeData dark() => _buildTheme(
    scheme: _darkScheme,
    scaffoldBg: AppColors.background,
    surface3: AppColors.surface3,
    textMuted: AppColors.textMuted,
    textDim: AppColors.textDim,
    drawerBg: AppColors.surface,
    bottomSheetBg: AppColors.surface,
    statusBarStyle: SystemUiOverlayStyle.light,
  );

  static ThemeData light() => _buildTheme(
    scheme: _lightScheme,
    scaffoldBg: AppColors.lightBackground,
    surface3: AppColors.lightSurface3,
    textMuted: AppColors.lightTextMuted,
    textDim: AppColors.lightTextDim,
    drawerBg: AppColors.lightSurface,
    bottomSheetBg: AppColors.lightSurface,
    statusBarStyle: SystemUiOverlayStyle.dark,
  );

  // ════════════════════════════════════════════════
  // MASTER BUILDER
  // ════════════════════════════════════════════════

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color scaffoldBg,
    required Color surface3,
    required Color textMuted,
    required Color textDim,
    required Color drawerBg,
    required Color bottomSheetBg,
    required SystemUiOverlayStyle statusBarStyle,
  }) => ThemeData(
    brightness: scheme.brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffoldBg,

    // ── TEXT ──────────────────────────────────
    textTheme: AppTextTheme.build(
      onSurface: scheme.onSurface,
      muted: textMuted,
      dim: textDim,
    ),

    // ── APP BAR ───────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: AppSizes.appBarHeightMd,
      systemOverlayStyle: statusBarStyle,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: textMuted, size: AppSizes.iconMd),
      actionsIconTheme: IconThemeData(color: textMuted, size: AppSizes.iconMd),
    ),

    // ── ELEVATED BUTTON ───────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.primaryContainer,
        disabledForegroundColor: textDim,
        elevation: 0,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: TextStyle(
          fontFamily: AppFonts.primaryFamily,
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),

    // ── TEXT BUTTON ───────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: TextStyle(
          fontFamily: AppFonts.primaryFamily,
          fontSize: AppSizes.fontMd,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── OUTLINED BUTTON ───────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textMuted,
        side: const BorderSide(
          color: AppColors.border,
          width: AppSizes.borderWidth,
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        textStyle: TextStyle(
          fontFamily: AppFonts.primaryFamily,
          fontSize: AppSizes.fontMd,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // ── INPUT DECORATION ──────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      prefixIconColor: textMuted,
      suffixIconColor: textMuted,
      hintStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontMd,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.inputPaddingH,
        vertical: AppSizes.inputPaddingV,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: scheme.outline,
          width: AppSizes.borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: scheme.outline,
          width: AppSizes.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: scheme.primary,
          width: AppSizes.borderWidthLg,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: scheme.error,
          width: AppSizes.borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide(
          color: scheme.error,
          width: AppSizes.borderWidthLg,
        ),
      ),
      errorStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontXs,
        color: scheme.error,
      ),
    ),

    // ── CARD ──────────────────────────────────
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
      ),
    ),

    // ── DRAWER ────────────────────────────────
    drawerTheme: DrawerThemeData(
      backgroundColor: drawerBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      width: AppSizes.drawerWidthMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSizes.radiusXl),
          bottomRight: Radius.circular(AppSizes.radiusXl),
        ),
      ),
    ),

    // ── LIST TILE ─────────────────────────────
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.listTilePaddingH,
        vertical: AppSizes.listTilePaddingV,
      ),
    ),

    // ── CHIP ──────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      selectedColor: scheme.primaryContainer,
      disabledColor: surface3,
      labelStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontXs,
        fontWeight: FontWeight.w700,
        color: textMuted,
      ),
      secondaryLabelStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontXs,
        fontWeight: FontWeight.w700,
        color: scheme.primary,
      ),
      side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.chipRadiusFull),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.chipPaddingH,
        vertical: AppSizes.chipPaddingV,
      ),
    ),

    // ── DIVIDER ───────────────────────────────
    dividerTheme: const DividerThemeData(
      thickness: AppSizes.dividerThickness,
      indent: AppSizes.dividerIndent,
      endIndent: AppSizes.dividerIndent,
      space: 0,
    ),

    // ── ICON ──────────────────────────────────
    iconTheme: IconThemeData(color: textMuted, size: AppSizes.iconMd),

    // ── BOTTOM SHEET ──────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bottomSheetBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.bottomSheetRadiusMd),
        ),
      ),
    ),

    // ── SNACK BAR ─────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      contentTextStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontMd,
        color: scheme.onSurface,
      ),
      actionTextColor: scheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
      ),
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.snackbarPaddingH,
        vertical: AppSizes.spaceSm,
      ),
    ),

    // ── DIALOG ────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
      ),
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontXxl,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
      contentTextStyle: TextStyle(
        fontFamily: AppFonts.primaryFamily,
        fontSize: AppSizes.fontMd,
        color: textMuted,
        height: AppSizes.lineHeightMd,
      ),
    ),

    // ── PROGRESS INDICATOR ────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.primaryContainer,
      circularTrackColor: scheme.primaryContainer,
    ),

    // ── SWITCH ────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return textDim;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return surface3;
      }),
    ),

    // ── CHECKBOX ──────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(scheme.onPrimary),
      side: const BorderSide(
        color: AppColors.border,
        width: AppSizes.borderWidthMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      ),
    ),

    // ── FAB ───────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.greenDark,
      foregroundColor: Colors.white,
      elevation: 0,
      iconSize: AppSizes.fabIconSize,
      shape: CircleBorder(),
    ),
  );
}
