/// ╔══════════════════════════════════════════════════════════════════╗
/// ║  ELEVATION TOKENS                                               ║
/// ║                                                                  ║
/// ║  Material 3 elevation levels mapped to semantic names.          ║
/// ║  Use in component themes — never hardcode a double.             ║
/// ╚══════════════════════════════════════════════════════════════════╝
abstract final class AppElevationTokens {
  static const double level0 = 0; // Cards at rest, surfaces
  static const double level1 = 1; // Filled buttons (pressed state)
  static const double level2 = 3; // FAB at rest, Menus, Chips
  static const double level3 = 6; // FAB pressed, Dialogs
  static const double level4 = 8; // Navigation drawer
  static const double level5 = 12; // Modals, bottom sheets

  // Semantic aliases
  static const double card = level0;
  static const double menu = level2;
  static const double dialog = level3;
  static const double drawer = level4;
  static const double bottomSheet = level5;
}
