import 'package:flutter/material.dart';
import 'app_fonts.dart';
import 'app_sizes.dart';

/// Text theme builder.
/// Called by AppTheme only — never called directly from widgets.
///
/// Uses Raw constants from AppSizes — no ScreenUtil dependency.
/// Uses AppFonts.primaryFamily directly — no object creation overhead.
/// Colors are injected per theme variant by AppTheme.

class AppTextTheme {
  AppTextTheme._();

  static TextTheme build({
    required Color onSurface,
    required Color muted,
    required Color dim,
  }) => const TextTheme().copyWith(
    // ── HEADINGS ──────────────────────────────────────
    headlineLarge: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.font4xl,
      fontWeight: FontWeight.w800,
      color: onSurface,
      height: AppSizes.lineHeightSm,
      letterSpacing: -0.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.font3xl,
      fontWeight: FontWeight.w800,
      color: onSurface,
      height: AppSizes.lineHeightSm,
    ),
    headlineSmall: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontXxl,
      fontWeight: FontWeight.w800,
      color: onSurface,
      height: AppSizes.lineHeightSm,
    ),

    // ── TITLES ────────────────────────────────────────
    titleLarge: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontXl,
      fontWeight: FontWeight.w700,
      color: onSurface,
      height: AppSizes.lineHeightSm,
    ),
    titleMedium: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontLg,
      fontWeight: FontWeight.w600,
      color: onSurface,
      height: AppSizes.lineHeightMd,
    ),
    titleSmall: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontMd,
      fontWeight: FontWeight.w600,
      color: onSurface,
      height: AppSizes.lineHeightMd,
    ),

    // ── BODY ──────────────────────────────────────────
    bodyLarge: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontMd,
      fontWeight: FontWeight.w400,
      color: onSurface,
      height: AppSizes.lineHeightMd,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontMd,
      fontWeight: FontWeight.w400,
      color: muted,
      height: AppSizes.lineHeightMd,
    ),
    bodySmall: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontSm,
      fontWeight: FontWeight.w400,
      color: muted,
      height: AppSizes.lineHeightMd,
    ),

    // ── LABELS ────────────────────────────────────────
    labelLarge: TextStyle(
      fontFamily: AppFonts.primaryFamily,
      fontSize: AppSizes.fontLg,
      fontWeight: FontWeight.w800,
      color: onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: AppFonts.monoFamily,
      fontSize: AppSizes.fontSm,
      fontWeight: FontWeight.w500,
      color: muted,
    ),
    labelSmall: TextStyle(
      fontFamily: AppFonts.monoFamily,
      fontSize: AppSizes.fontXxs,
      fontWeight: FontWeight.w400,
      color: dim,
      letterSpacing: 0.08,
    ),
  );
}
