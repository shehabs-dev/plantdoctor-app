import 'package:flutter/material.dart';
import 'app_palette.dart';

/// Material 3 [ColorScheme] definitions — single source of truth.
///
/// Reads exclusively from [AppPalette] which reads from [AppConfig].
/// To rebrand → change [AppConfig] only. Nothing here needs editing.
abstract final class AppColorSchemes {
  // ─────────────────────────────────────────────────────────────────
  // DARK — "Dark Field"
  // ─────────────────────────────────────────────────────────────────
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    // ── Primary ───────────────────────────────────────────────────
    primary: AppPalette.primary400,
    onPrimary: AppPalette.white,
    primaryContainer: AppPalette.primaryContainer900,
    onPrimaryContainer: AppPalette.primaryContainer100,

    // ── Secondary ─────────────────────────────────────────────────
    secondary: AppPalette.secondary400,
    onSecondary: AppPalette.white,
    secondaryContainer: AppPalette.secondaryContainer900,
    onSecondaryContainer: AppPalette.secondaryContainer100,

    // ── Tertiary ──────────────────────────────────────────────────
    tertiary: AppPalette.tertiary400,
    onTertiary: AppPalette.white,
    tertiaryContainer: AppPalette.tertiaryContainer900,
    onTertiaryContainer: AppPalette.tertiaryContainer100,

    // ── Error ─────────────────────────────────────────────────────
    error: AppPalette.error400,
    onError: AppPalette.white,
    errorContainer: AppPalette.errorContainer900,
    onErrorContainer: AppPalette.errorContainer100,

    // ── Surface hierarchy ─────────────────────────────────────────
    surface: AppPalette.darkSurface,
    onSurface: AppPalette.darkOnSurface,
    surfaceContainerLowest: AppPalette.darkScaffold,
    surfaceContainerLow: AppPalette.darkSurface,
    surfaceContainer: AppPalette.darkSurfaceContainer,
    surfaceContainerHigh: AppPalette.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppPalette.darkSurfaceContainerHigh,
    onSurfaceVariant: AppPalette.darkOnSurfaceVariant,

    // ── Inverse ───────────────────────────────────────────────────
    inverseSurface: AppPalette.darkOnSurface,
    onInverseSurface: AppPalette.darkScaffold,
    inversePrimary: AppPalette.primary500,

    // ── Outline ───────────────────────────────────────────────────
    outline: AppPalette.darkOutline,
    outlineVariant: AppPalette.darkOutlineVariant,

    // ── Misc ──────────────────────────────────────────────────────
    scrim: AppPalette.black,
    shadow: AppPalette.black,
  );

  // ─────────────────────────────────────────────────────────────────
  // LIGHT — "Light Field"
  // ─────────────────────────────────────────────────────────────────
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // ── Primary ───────────────────────────────────────────────────
    primary: AppPalette.primary500,
    onPrimary: AppPalette.white,
    primaryContainer: AppPalette.primaryContainer100,
    onPrimaryContainer: AppPalette.primary500,

    // ── Secondary ─────────────────────────────────────────────────
    secondary: AppPalette.secondary500,
    onSecondary: AppPalette.white,
    secondaryContainer: AppPalette.secondaryContainer100,
    onSecondaryContainer: AppPalette.secondary500,

    // ── Tertiary ──────────────────────────────────────────────────
    tertiary: AppPalette.tertiary500,
    onTertiary: AppPalette.white,
    tertiaryContainer: AppPalette.tertiaryContainer100,
    onTertiaryContainer: AppPalette.tertiary500,

    // ── Error ─────────────────────────────────────────────────────
    error: AppPalette.error500,
    onError: AppPalette.white,
    errorContainer: AppPalette.errorContainer100,
    onErrorContainer: AppPalette.error500,

    // ── Surface hierarchy ─────────────────────────────────────────
    surface: AppPalette.lightSurface,
    onSurface: AppPalette.lightOnSurface,
    surfaceContainerLowest: AppPalette.lightScaffold,
    surfaceContainerLow: AppPalette.lightSurface,
    surfaceContainer: AppPalette.lightSurfaceContainer,
    surfaceContainerHigh: AppPalette.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppPalette.lightSurfaceContainerHigh,
    onSurfaceVariant: AppPalette.lightOnSurfaceVariant,

    // ── Inverse ───────────────────────────────────────────────────
    inverseSurface: AppPalette.lightOnSurface,
    onInverseSurface: AppPalette.lightSurface,
    inversePrimary: AppPalette.primary400,

    // ── Outline ───────────────────────────────────────────────────
    outline: AppPalette.lightOutline,
    outlineVariant: AppPalette.lightOutlineVariant,

    // ── Misc ──────────────────────────────────────────────────────
    scrim: AppPalette.black,
    shadow: AppPalette.black,
  );
}
