# Design System

> **One file to rebrand the entire app → `config/app_config.dart`**

## Folder structure

```
theme/
├── README.md                       ← you are here
├── design_system.dart              ← single barrel import for all widgets
│
├── config/
│   └── app_config.dart             ★ THE ONLY FILE YOU EVER EDIT
│                                     fonts · colors · brand palette
│
├── colors/
│   ├── app_palette.dart            maps AppConfig values → named slots
│   └── app_color_schemes.dart      Material 3 ColorScheme (light + dark)
│
├── tokens/                         primitive design tokens (no Flutter dependency)
│   ├── app_motion_tokens.dart      durations + curves
│   ├── app_elevation_tokens.dart   elevation levels (M3 0-5 scale)
│   └── app_spacing_tokens.dart     4-pt grid base constant
│
├── extensions/
│   └── app_theme_extension.dart    semantic colors: success / warning / info
│
├── builder/
│   └── app_theme_builder.dart      public API → .light() / .dark() / .custom()
│
├── app_component_themes.dart       per-widget ThemeData factories
├── app_typography.dart             TextTheme builder
└── app_sizes.dart                  spacing · radius · font · icon raw + scaled
```

## Usage

```dart
// In MaterialApp — this is the only place you touch outside this folder
MaterialApp(
  theme:     AppThemeBuilder.light(),
  darkTheme: AppThemeBuilder.dark(),
  themeMode: ThemeMode.system,
)

// In any widget
final cs  = Theme.of(context).colorScheme;
final ext = Theme.of(context).extension<AppThemeExtension>()!;

Container(
  color: ext.successContainer,
  child: Text('Done', style: TextStyle(color: ext.onSuccessContainer)),
)
```

## Data flow (read-only)

```
AppConfig          → raw brand values (hex colors, font names)
    ↓
AppPalette         → named color slots (primary400, darkScaffold, …)
    ↓
AppColorSchemes    → Material 3 ColorScheme (light / dark)
    ↓
AppThemeBuilder    → ThemeData (wires ColorScheme + typography + components)
    ↓
Widget tree        → Theme.of(context).colorScheme / extension<AppThemeExtension>
```

## How to rebrand

1. Open `config/app_config.dart`.
2. Change any color constants.
3. Hot-reload. Done.

**Never** import `AppPalette`, `AppColorSchemes`, or `AppComponentThemes` directly
in widget code. Always go through `colorScheme` or `AppThemeExtension`.

## Motion

```dart
AnimatedContainer(
  duration: AppMotionTokens.normal,   // 250 ms
  curve:    AppMotionTokens.standard, // easeInOut
)
```

## Elevation

```dart
Card(elevation: AppElevationTokens.card)     // 0
Dialog(elevation: AppElevationTokens.dialog) // 6
```

## Spacing

All raw constants live in `AppSizes`. Scaled (ScreenUtil) variants use
the `Scaled` suffix — only inside `build()` after `ScreenUtilInit`.

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: AppSizes.screenPaddingHScaled,
    vertical:   AppSizes.screenPaddingVScaled,
  ),
)
```
