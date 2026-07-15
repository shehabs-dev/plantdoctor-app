import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system.dart';

/// Public API for the design system.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme:      AppThemeBuilder.light(),
///   darkTheme:  AppThemeBuilder.dark(),
///   themeMode:  ThemeMode.system,
/// )
/// ```
///
/// Multi-brand / custom variant:
/// ```dart
/// AppThemeBuilder.custom(
///   scheme: myBrandColorScheme,
///   extension: myBrandExtension,
/// )
/// ```
abstract final class AppThemeBuilder {
  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC PRESETS
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData light() => _build(
    scheme: AppColorSchemes.light,
    extension: AppThemeExtension.light,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static ThemeData dark() => _build(
    scheme: AppColorSchemes.dark,
    extension: AppThemeExtension.dark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  /// Drop-in for multi-brand or white-label apps.
  /// Supply a fully-formed [ColorScheme] and matching [AppThemeExtension].
  static ThemeData custom({
    required ColorScheme scheme,
    required AppThemeExtension extension,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) => _build(
    scheme: scheme,
    extension: extension,
    systemOverlayStyle:
        systemOverlayStyle ??
        (scheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // MASTER BUILDER — private
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData _build({
    required ColorScheme scheme,
    required AppThemeExtension extension,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,

      // ── Scaffold ────────────────────────────────────────────────
      // surfaceContainerLowest is the deepest surface — perfect for scaffold.
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,

      // ── Typography ──────────────────────────────────────────────
      fontFamily: AppConfig.primaryFont,
      textTheme: AppTypography.buildTextTheme(
        onSurface: scheme.onSurface,
        onSurfaceVariant: scheme.onSurfaceVariant,
        onSurfaceDim: extension.onSurfaceDim,
      ),

      // ── Icon ────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
        size: AppSizes.iconMd,
      ),

      // ── Extensions ──────────────────────────────────────────────
      extensions: [extension],

      // ── Components ──────────────────────────────────────────────
      appBarTheme: AppComponentThemes.appBar(
        scheme: scheme,
        overlayStyle: systemOverlayStyle,
      ),
      elevatedButtonTheme: AppComponentThemes.elevatedButton(scheme: scheme),
      textButtonTheme: AppComponentThemes.textButton(scheme: scheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButton(scheme: scheme),
      inputDecorationTheme: AppComponentThemes.inputDecoration(scheme: scheme),
      cardTheme: AppComponentThemes.card(scheme: scheme),
      chipTheme: AppComponentThemes.chip(scheme: scheme),
      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBar(
        scheme: scheme,
      ),
      navigationBarTheme: AppComponentThemes.navigationBar(scheme: scheme),
      floatingActionButtonTheme: AppComponentThemes.fab(scheme: scheme),
      dialogTheme: AppComponentThemes.dialog(scheme: scheme),
      drawerTheme: AppComponentThemes.drawer(scheme: scheme),
      bottomSheetTheme: AppComponentThemes.bottomSheet(scheme: scheme),
      snackBarTheme: AppComponentThemes.snackBar(scheme: scheme),
      listTileTheme: AppComponentThemes.listTile(scheme: scheme),
      dividerTheme: AppComponentThemes.divider(scheme: scheme),
      switchTheme: AppComponentThemes.switchTheme(scheme: scheme),
      checkboxTheme: AppComponentThemes.checkbox(scheme: scheme),
      progressIndicatorTheme: AppComponentThemes.progressIndicator(
        scheme: scheme,
      ),
      tabBarTheme: AppComponentThemes.tabBar(scheme: scheme),
      tooltipTheme: AppComponentThemes.tooltip(scheme: scheme),
      radioTheme: AppComponentThemes.radio(scheme: scheme),
      sliderTheme: AppComponentThemes.slider(scheme: scheme),
      badgeTheme: AppComponentThemes.badge(scheme: scheme),
      searchBarTheme: AppComponentThemes.searchBar(scheme: scheme),
      datePickerTheme: AppComponentThemes.datePicker(scheme: scheme),
      timePickerTheme: AppComponentThemes.timePicker(scheme: scheme),
      popupMenuTheme: AppComponentThemes.popupMenu(scheme: scheme),
      expansionTileTheme: AppComponentThemes.expansionTile(scheme: scheme),
    );
  }
}
