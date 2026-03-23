import 'package:flutter/material.dart';

import '../assets/app_assets.dart';

class AppFonts {
  AppFonts._();

  // ── FONT FAMILY CONSTANTS ─────────────────────
  // Use these directly in ThemeData — no object creation overhead
  static const String primaryFamily = AppAssets.primaryFamily;
  static const String monoFamily = AppAssets.monoFamily;

  // ── TEXT STYLE BUILDERS ───────────────────────
  // Use these when you need a full TextStyle with optional overrides
  static TextStyle primary({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: primaryFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: monoFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextTheme get primaryTextTheme => const TextTheme();
}
