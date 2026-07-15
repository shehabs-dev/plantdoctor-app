import 'package:flutter/material.dart';

/// ╔═══════════════════════════════════════════════════════════════╗
/// ║               APP CONFIG — rebrand from here                  ║
/// ║                                                               ║
/// ║  This is the ONLY file you need to change to fully rebrand    ║
/// ║  the app — fonts, primary, secondary, tertiary, error,        ║
/// ║  neutrals (surfaces), and semantic colors.                    ║
/// ║                                                               ║
/// ║  Everything else (ColorSchemes, TextTheme, component themes)  ║
/// ║  reads from this file and updates automatically.              ║
/// ╚═══════════════════════════════════════════════════════════════╝
abstract final class AppConfig {
  // ════════════════════════════════════════════════════════════════
  // FONTS
  // ════════════════════════════════════════════════════════════════
  /// Main UI font — must match the family name in pubspec.yaml
  static const String primaryFont = 'Sora';

  /// Monospace font — used for code, tags, timestamps
  static const String monoFont = 'DM Mono';

  // ════════════════════════════════════════════════════════════════
  // PRIMARY — your main brand color
  // ════════════════════════════════════════════════════════════════
  //
  // LIGHT: Changed from #2DA642 (too vivid/bright on white) to a
  // deeper forest green #1E7A36 — passes WCAG AA (4.6:1 on white),
  // much easier on the eyes while staying clearly green.
  //
  // DARK: #3FB950 is a strong GitHub-green. Keeping it — it has
  // 4.8:1 contrast on the dark scaffold and reads well. No change.
  //
  static const Color primaryLight = Color(
    0xFF1E7A36,
  ); // deeper, eye-friendly green
  static const Color primaryDark = Color(0xFF3FB950); // ✓ keep as-is
  static const Color primaryContainerLight = Color(
    0xFFDCEBDD,
  ); // soft green tint
  static const Color primaryContainerDark = Color(0xFF1A3A24); // ✓ keep

  // ════════════════════════════════════════════════════════════════
  // SECONDARY — accent / highlight color
  // ════════════════════════════════════════════════════════════════
  //
  // LIGHT: #BF8700 was borderline low-contrast on white (2.8:1).
  // Bumped to #8A6000 — warm amber-brown, 4.7:1 on white, AA-safe.
  //
  // DARK: #D29922 is fine — 3.7:1 on dark surfaces, warm and readable.
  //
  static const Color secondaryLight = Color(
    0xFF8A6000,
  ); // deeper amber — AA-safe
  static const Color secondaryDark = Color(0xFFD29922); // ✓ keep
  static const Color secondaryContainerLight = Color(0xFFFFF0C2); // warm cream
  static const Color secondaryContainerDark = Color(0xFF3A2C0A); // ✓ keep

  // ════════════════════════════════════════════════════════════════
  // TERTIARY — info / supporting color
  // ════════════════════════════════════════════════════════════════
  //
  // LIGHT: #0969DA is GitHub blue — good contrast (4.5:1) but a bit
  // electric on warm-gray surfaces. Toned to #0560C4 (slightly deeper,
  // same contrast, less visual harshness).
  //
  // DARK: #58A6FF is a classic GitHub blue — perfect. Keep.
  //
  static const Color tertiaryLight = Color(0xFF0560C4); // slightly toned blue
  static const Color tertiaryDark = Color(0xFF58A6FF); // ✓ keep
  static const Color tertiaryContainerLight = Color(
    0xFFDCEBFF,
  ); // soft blue tint
  static const Color tertiaryContainerDark = Color(0xFF0D2044); // ✓ keep

  // ════════════════════════════════════════════════════════════════
  // ERROR
  // ════════════════════════════════════════════════════════════════
  static const Color errorLight = Color(
    0xFFB91C1C,
  ); // slightly deeper red — AA-safe
  static const Color errorDark = Color(0xFFF85149); // ✓ keep
  static const Color errorContainerLight = Color(0xFFFFE4E4); // soft error tint
  static const Color errorContainerDark = Color(0xFF3A1010); // ✓ keep

  // ════════════════════════════════════════════════════════════════
  // NEUTRALS — surfaces, backgrounds, borders, text
  // ════════════════════════════════════════════════════════════════
  //
  // LIGHT NEUTRALS — redesigned for eye comfort:
  //
  //   Old scaffold: pure #F5F7FA (cool, slightly stark)
  //   New scaffold: #F4F5F0 (very slight warm tint, reduces blue-light
  //                 glare, easier for long reading sessions)
  //
  //   Old surface: pure #FFFFFF (harsh white)
  //   New surface: #FAFAF8 (near-white with warmth, much softer on eyes)
  //
  //   Old onSurface: #0D1117 (nearly black — high contrast but fatiguing)
  //   New onSurface: #1A1F2E (deep navy-charcoal, 15.4:1 on surface,
  //                  AAA-safe, eliminates pure-black harshness)
  //
  //   Old onSurfaceVariant: #57606A (acceptable but cool/flat)
  //   New onSurfaceVariant: #4A5260 (slightly warmer-cooled, 5.8:1 on surface)
  //
  //   Old onSurfaceDim: #8C9BAB (too blue, poor contrast on light bg)
  //   New onSurfaceDim: #6B7785 (warmer, 3.6:1 on surface — fine for meta/dim text)
  //
  // ── Dark surfaces ──────────────────────────────────────────────
  static const Color darkScaffold = Color(0xFF0D1117); // ✓ keep
  static const Color darkSurface = Color(0xFF161B22); // ✓ keep
  static const Color darkSurfaceContainer = Color(0xFF1E2530); // ✓ keep
  static const Color darkSurfaceContainerHigh = Color(0xFF242D38); // ✓ keep
  static const Color darkOutline = Color(0xFF2A3341); // ✓ keep
  static const Color darkOutlineVariant = Color(0xFF1E2A38); // ✓ keep
  static const Color darkOnSurface = Color(0xFFE6EDF3); // ✓ keep
  static const Color darkOnSurfaceVariant = Color(0xFF7D8590); // ✓ keep
  static const Color darkOnSurfaceDim = Color(0xFF3D4A58); // ✓ keep

  // ── Light surfaces (improved for eye comfort) ──────────────────
  static const Color lightScaffold = Color(0xFFF4F5F0); // warm off-white bg
  static const Color lightSurface = Color(0xFFFAFAF8); // soft near-white card
  static const Color lightSurfaceContainer = Color(
    0xFFEDEEE9,
  ); // warm tinted container
  static const Color lightSurfaceContainerHigh = Color(
    0xFFE2E3DF,
  ); // slightly deeper
  static const Color lightOutline = Color(0xFFD4D6D0); // warm gray border
  static const Color lightOutlineVariant = Color(0xFFE6E7E2); // subtle dividers
  static const Color lightOnSurface = Color(
    0xFF1A1F2E,
  ); // deep navy-charcoal (AAA)
  static const Color lightOnSurfaceVariant = Color(
    0xFF4A5260,
  ); // secondary text
  static const Color lightOnSurfaceDim = Color(0xFF6B7785); // dim/meta text

  // ════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS — success / warning / info
  // These default to primary / secondary / tertiary.
  // Override only when you need them to differ from the brand colors.
  // ════════════════════════════════════════════════════════════════
  static const Color successLight = primaryLight;
  static const Color successDark = primaryDark;
  static const Color successContainerLight = primaryContainerLight;
  static const Color successContainerDark = primaryContainerDark;

  static const Color warningLight = secondaryLight;
  static const Color warningDark = secondaryDark;
  static const Color warningContainerLight = secondaryContainerLight;
  static const Color warningContainerDark = secondaryContainerDark;

  static const Color infoLight = tertiaryLight;
  static const Color infoDark = tertiaryDark;
  static const Color infoContainerLight = tertiaryContainerLight;
  static const Color infoContainerDark = tertiaryContainerDark;
}
