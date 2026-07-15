import 'package:flutter/material.dart';

import '../design_system.dart';

/// Raw color palette — maps [AppConfig] values into named slots.
///
/// ⚠️  Do NOT import or use this in widgets or components.
///     It exists solely to feed [AppColorSchemes] and [AppThemeExtension].
///     UI code reads exclusively from [colorScheme] or [AppThemeExtension].
///
/// To change any color → edit [AppConfig] only.
abstract final class AppPalette {
  // ── Primary ──────────────────────────────────────────────────────
  static const Color primary400 = AppConfig.primaryDark;
  static const Color primary500 = AppConfig.primaryLight;
  static const Color primaryContainer100 = AppConfig.primaryContainerLight;
  static const Color primaryContainer900 = AppConfig.primaryContainerDark;

  // ── Secondary ────────────────────────────────────────────────────
  static const Color secondary400 = AppConfig.secondaryDark;
  static const Color secondary500 = AppConfig.secondaryLight;
  static const Color secondaryContainer100 = AppConfig.secondaryContainerLight;
  static const Color secondaryContainer900 = AppConfig.secondaryContainerDark;

  // ── Tertiary ─────────────────────────────────────────────────────
  static const Color tertiary400 = AppConfig.tertiaryDark;
  static const Color tertiary500 = AppConfig.tertiaryLight;
  static const Color tertiaryContainer100 = AppConfig.tertiaryContainerLight;
  static const Color tertiaryContainer900 = AppConfig.tertiaryContainerDark;

  // ── Error ────────────────────────────────────────────────────────
  static const Color error400 = AppConfig.errorDark;
  static const Color error500 = AppConfig.errorLight;
  static const Color errorContainer100 = AppConfig.errorContainerLight;
  static const Color errorContainer900 = AppConfig.errorContainerDark;

  // ── Dark neutrals ────────────────────────────────────────────────
  static const Color darkScaffold = AppConfig.darkScaffold;
  static const Color darkSurface = AppConfig.darkSurface;
  static const Color darkSurfaceContainer = AppConfig.darkSurfaceContainer;
  static const Color darkSurfaceContainerHigh =
      AppConfig.darkSurfaceContainerHigh;
  static const Color darkOutline = AppConfig.darkOutline;
  static const Color darkOutlineVariant = AppConfig.darkOutlineVariant;
  static const Color darkOnSurface = AppConfig.darkOnSurface;
  static const Color darkOnSurfaceVariant = AppConfig.darkOnSurfaceVariant;
  static const Color darkOnSurfaceDim = AppConfig.darkOnSurfaceDim;

  // ── Light neutrals ───────────────────────────────────────────────
  static const Color lightScaffold = AppConfig.lightScaffold;
  static const Color lightSurface = AppConfig.lightSurface;
  static const Color lightSurfaceContainer = AppConfig.lightSurfaceContainer;
  static const Color lightSurfaceContainerHigh =
      AppConfig.lightSurfaceContainerHigh;
  static const Color lightOutline = AppConfig.lightOutline;
  static const Color lightOutlineVariant = AppConfig.lightOutlineVariant;
  static const Color lightOnSurface = AppConfig.lightOnSurface;
  static const Color lightOnSurfaceVariant = AppConfig.lightOnSurfaceVariant;
  static const Color lightOnSurfaceDim = AppConfig.lightOnSurfaceDim;

  // ── Always ───────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}
