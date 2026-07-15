/// ╔══════════════════════════════════════════════════════════════════╗
/// ║  SPACING TOKENS — primitive scale fed from AppConfig            ║
/// ║                                                                  ║
/// ║  Use these in AppSizes. Never import this directly in widgets.   ║
/// ╚══════════════════════════════════════════════════════════════════╝
///
/// This file exists so AppConfig can one day expose spacing overrides
/// without touching AppSizes. Currently a thin alias layer.
abstract final class AppSpacingTokens {
  static const double base = 4; // 4-pt grid base
}
