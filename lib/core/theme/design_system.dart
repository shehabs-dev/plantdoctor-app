/// Design System — single import barrel.
///
/// Add this one import to any file that needs design tokens or themes:
/// ```dart
/// import 'package:your_app/design_system/design_system.dart';
/// ```
///
/// ┌──────────────────────────────────────────────────────────────┐
/// │  TO REBRAND → edit app_config.dart ONLY                      │
/// │  fonts, primary, secondary, tertiary, neutrals,              │
/// │  semantic colors — all flow from that one file.              │
/// └──────────────────────────────────────────────────────────────┘
///
/// Public surface:
///   [AppConfig]            → ★ single rebrand dial
///   [AppThemeBuilder]      → build light / dark / custom ThemeData
///   [AppThemeExtension]    → semantic colors (success, warning, info)
///   [AppSizes]             → spacing, radius, font-size, icon-size
///   [AppTypography]        → font family constants
///   [AppMotionTokens]      → durations & curves
///   [AppElevationTokens]   → elevation levels
///
/// Internal (do NOT import directly in UI):
///   AppPalette             → raw color slots (feeds ColorSchemes only)
///   AppColorSchemes        → Material 3 ColorScheme presets
///   AppComponentThemes     → per-component theme factories
///   AppSpacingTokens       → spacing primitive scale
library;

export 'config/app_config.dart';
export 'colors/app_color_schemes.dart';
export 'colors/app_palette.dart';
export 'app_component_themes.dart';
export 'extensions/app_theme_extension.dart';
export 'app_sizes.dart';
export 'builder/app_theme_builder.dart';
export 'app_typography.dart';
export 'tokens/app_motion_tokens.dart';
export 'tokens/app_elevation_tokens.dart';
export 'tokens/app_spacing_tokens.dart';
