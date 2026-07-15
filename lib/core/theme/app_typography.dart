import 'package:flutter/material.dart';

import 'design_system.dart';

/// Font families and ALL named text styles for the app.
///
/// ── Rules ────────────────────────────────────────────────────────
/// • Font family strings live in [AppConfig] ONLY.
///   No raw font-family string anywhere else in the codebase.
/// • Colors are injected via [buildTextTheme] — never hardcoded here.
/// • [AppComponentThemes] references named styles from this class
///   instead of building its own inline [TextStyle] objects.
/// ─────────────────────────────────────────────────────────────────
abstract final class AppTypography {
  // ════════════════════════════════════════════════════════════════
  // NAMED COMPONENT STYLES
  // Used by AppComponentThemes — color is intentionally omitted so
  // each component can apply the correct scheme color via .copyWith().
  // ════════════════════════════════════════════════════════════════

  // ── App bar ──────────────────────────────────────────────────────
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w800,
  );

  // ── Buttons ──────────────────────────────────────────────────────
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
  );

  // ── Input / form ─────────────────────────────────────────────────
  static const TextStyle inputHint = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle inputError = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w400,
  );

  // ── Chip ─────────────────────────────────────────────────────────
  static const TextStyle chipLabel = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w700,
  );

  // ── Bottom nav / Navigation bar ──────────────────────────────────
  static const TextStyle navLabelSelected = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle navLabelUnselected = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w400,
  );

  // ── Dialog ───────────────────────────────────────────────────────
  static const TextStyle dialogTitle = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXxl,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle dialogContent = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
    height: AppSizes.lineHeightMd,
  );

  // ── Snack bar ────────────────────────────────────────────────────
  static const TextStyle snackBarContent = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
  );

  // ── Tab bar ──────────────────────────────────────────────────────
  static const TextStyle tabSelected = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabUnselected = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
  );

  // ── Tooltip ──────────────────────────────────────────────────────
  static const TextStyle tooltip = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w400,
  );

  // ── Badge ────────────────────────────────────────────────────────
  static const TextStyle badge = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontXxs,
    fontWeight: FontWeight.w600,
  );

  // ── Date picker ──────────────────────────────────────────────────
  static const TextStyle datePickerDay = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
  );

  // ── Popup menu ───────────────────────────────────────────────────
  static const TextStyle popupMenuItem = TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
  );

  // ════════════════════════════════════════════════════════════════
  // TEXT THEME BUILDER
  //
  // Called by [AppThemeBuilder] only — never directly from widgets.
  //
  // Colors injected from resolved ColorScheme + AppThemeExtension:
  //   onSurface        → headings, titles, primary body
  //   onSurfaceVariant → secondary body, captions
  //   onSurfaceDim     → timestamps, metadata, micro labels
  // ════════════════════════════════════════════════════════════════
  static TextTheme buildTextTheme({
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color onSurfaceDim,
  }) {
    return TextTheme(
      // ── Display ────────────────────────────────────────────────
      displayLarge: _p(
        size: 57,
        weight: FontWeight.w700,
        color: onSurface,
        height: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: _p(
        size: 45,
        weight: FontWeight.w700,
        color: onSurface,
        height: 1.16,
      ),
      displaySmall: _p(
        size: 36,
        weight: FontWeight.w600,
        color: onSurface,
        height: 1.22,
      ),

      // ── Headline ───────────────────────────────────────────────
      headlineLarge: _p(
        size: AppSizes.font4xl,
        weight: FontWeight.w800,
        color: onSurface,
        height: AppSizes.lineHeightSm,
        letterSpacing: -0.3,
      ),
      headlineMedium: _p(
        size: AppSizes.font3xl,
        weight: FontWeight.w800,
        color: onSurface,
        height: AppSizes.lineHeightSm,
      ),
      headlineSmall: _p(
        size: AppSizes.fontXxl,
        weight: FontWeight.w800,
        color: onSurface,
        height: AppSizes.lineHeightSm,
      ),

      // ── Title ──────────────────────────────────────────────────
      titleLarge: _p(
        size: AppSizes.fontXl,
        weight: FontWeight.w700,
        color: onSurface,
        height: AppSizes.lineHeightSm,
      ),
      titleMedium: _p(
        size: AppSizes.fontLg,
        weight: FontWeight.w600,
        color: onSurface,
        height: AppSizes.lineHeightMd,
      ),
      titleSmall: _p(
        size: AppSizes.fontMd,
        weight: FontWeight.w600,
        color: onSurface,
        height: AppSizes.lineHeightMd,
      ),

      // ── Body ───────────────────────────────────────────────────
      bodyLarge: _p(
        size: AppSizes.fontMd,
        weight: FontWeight.w400,
        color: onSurface,
        height: AppSizes.lineHeightMd,
      ),
      bodyMedium: _p(
        size: AppSizes.fontMd,
        weight: FontWeight.w400,
        color: onSurfaceVariant,
        height: AppSizes.lineHeightMd,
      ),
      bodySmall: _p(
        size: AppSizes.fontSm,
        weight: FontWeight.w400,
        color: onSurfaceVariant,
        height: AppSizes.lineHeightMd,
      ),

      // ── Label ──────────────────────────────────────────────────
      labelLarge: _p(
        size: AppSizes.fontLg,
        weight: FontWeight.w800,
        color: onSurface,
      ),
      labelMedium: _m(
        size: AppSizes.fontSm,
        weight: FontWeight.w500,
        color: onSurfaceVariant,
      ),
      labelSmall: _m(
        size: AppSizes.fontXxs,
        weight: FontWeight.w400,
        color: onSurfaceDim,
        letterSpacing: 0.08,
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS — do not use outside this file
  // ════════════════════════════════════════════════════════════════

  static TextStyle _p({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: AppConfig.primaryFont,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextStyle _m({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: AppConfig.monoFont,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
