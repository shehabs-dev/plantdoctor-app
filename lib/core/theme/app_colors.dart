import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ════════════════════════════════════════════════
  // DARK THEME — "Dark Field"
  // ════════════════════════════════════════════════

  // ── BACKGROUNDS ───────────────────────────────
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surface2 = Color(0xFF1E2530);
  static const Color surface3 = Color(0xFF242D38);

  // ── BORDERS ───────────────────────────────────
  static const Color border = Color(0xFF2A3341);
  static const Color borderSoft = Color(0xFF1E2A38);

  // ── TEXT ──────────────────────────────────────
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textMuted = Color(0xFF7D8590);
  static const Color textDim = Color(0xFF3D4A58);

  // ════════════════════════════════════════════════
  // LIGHT THEME — "Light Field"
  // ════════════════════════════════════════════════

  // ── BACKGROUNDS ───────────────────────────────
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFEEF1F5);
  static const Color lightSurface3 = Color(0xFFE4E8EF);

  // ── BORDERS ───────────────────────────────────
  static const Color lightBorder = Color(0xFFD8DEE8);
  static const Color lightBorderSoft = Color(0xFFE8ECF2);

  // ── TEXT ──────────────────────────────────────
  static const Color lightTextPrimary = Color(0xFF0D1117);
  static const Color lightTextMuted = Color(0xFF57606A);
  static const Color lightTextDim = Color(0xFF8C9BAB);

  // ════════════════════════════════════════════════
  // SHARED — same across both themes
  // ════════════════════════════════════════════════

  // ── PRIMARY — GREEN ───────────────────────────
  static const Color green = Color(
    0xFF2DA642,
  ); // slightly deeper for light readability
  static const Color greenDark = Color(
    0xFF3FB950,
  ); // original green — use on dark theme
  static const Color greenDim = Color(0xFFDFF5E3); // light theme tint
  static const Color greenDimDark = Color(0xFF1A3A24); // dark theme tint
  static const Color greenMid = Color(0xFF4CAF64);

  // ── SECONDARY — AMBER ─────────────────────────
  static const Color amber = Color(0xFFBF8700); // darker for light contrast
  static const Color amberDark = Color(0xFFD29922); // original — use on dark
  static const Color amberDim = Color(0xFFFFF3CC); // light theme tint
  static const Color amberDimDark = Color(0xFF3A2C0A); // dark theme tint

  // ── INFO — BLUE ───────────────────────────────
  static const Color blue = Color(0xFF0969DA); // darker for light contrast
  static const Color blueDark = Color(0xFF58A6FF); // original — use on dark
  static const Color blueDim = Color(0xFFDCEEFF); // light theme tint
  static const Color blueDimDark = Color(0xFF0D2044); // dark theme tint

  // ── ERROR — RED ───────────────────────────────
  static const Color red = Color(0xFFCF222E); // darker for light contrast
  static const Color redDark = Color(0xFFF85149); // original — use on dark
  static const Color redDim = Color(0xFFFFDEDD); // light theme tint
  static const Color redDimDark = Color(0xFF3A1010); // dark theme tint

  // ── SUCCESS — same in both ────────────────────
  static const Color success = Color(0xFF1A7F37);
  static const Color successDark = Color(0xFF3FB950);
}
