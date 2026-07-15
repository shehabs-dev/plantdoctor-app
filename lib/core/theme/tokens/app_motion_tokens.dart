import 'package:flutter/animation.dart';

/// ╔══════════════════════════════════════════════════════════════════╗
/// ║  MOTION TOKENS — durations & curves                             ║
/// ║                                                                  ║
/// ║  Centralises all animation timing so you never hunt for         ║
/// ║  hardcoded Duration(milliseconds: 200) across the codebase.     ║
/// ╚══════════════════════════════════════════════════════════════════╝
abstract final class AppMotionTokens {
  // ── Durations ────────────────────────────────────────────────────
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration slowest = Duration(milliseconds: 500);
  static const Duration pageEnter = Duration(milliseconds: 300);
  static const Duration pageExit = Duration(milliseconds: 200);

  // ── Curves ───────────────────────────────────────────────────────
  /// Default for most transitions — feels natural and snappy.
  static const Curve standard = Curves.easeInOut;

  /// For elements entering the screen (slides in, fades in).
  static const Curve decelerate = Curves.easeOut;

  /// For elements exiting the screen.
  static const Curve accelerate = Curves.easeIn;

  /// For springy interactions (FAB, bottom sheet).
  static const Curve spring = Curves.elasticOut;

  /// For linear progress bars / shimmer.
  static const Curve linear = Curves.linear;
}
