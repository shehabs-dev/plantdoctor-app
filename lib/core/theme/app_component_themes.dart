import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_system.dart';

/// Component-level theme factories.
///
/// ── Rules ────────────────────────────────────────────────────────
/// • Never construct a [TextStyle] with a fontFamily here.
///   All text styles come from [AppTypography] via .copyWith(color:).
/// • Never reference [AppConfig] directly — go through [AppTypography]
///   for text and [AppElevationTokens] for elevation values.
/// • Called exclusively by [AppThemeBuilder._build].
///   Never called from UI widgets.
/// ─────────────────────────────────────────────────────────────────
abstract final class AppComponentThemes {
  // ─────────────────────────────────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────────────────────────────────
  static AppBarTheme appBar({
    required ColorScheme scheme,
    required SystemUiOverlayStyle overlayStyle,
  }) => AppBarTheme(
    backgroundColor: scheme.surface,
    foregroundColor: scheme.onSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: AppElevationTokens.level0,
    scrolledUnderElevation: AppElevationTokens.level0,
    centerTitle: true,
    toolbarHeight: AppSizes.appBarHeightMd,
    systemOverlayStyle: overlayStyle,
    titleTextStyle: AppTypography.appBarTitle.copyWith(color: scheme.onSurface),
    iconTheme: IconThemeData(
      color: scheme.onSurfaceVariant,
      size: AppSizes.iconMd,
    ),
    actionsIconTheme: IconThemeData(
      color: scheme.onSurfaceVariant,
      size: AppSizes.iconMd,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // ELEVATED BUTTON
  // ─────────────────────────────────────────────────────────────────────────
  static ElevatedButtonThemeData elevatedButton({
    required ColorScheme scheme,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      disabledBackgroundColor: scheme.primaryContainer,
      disabledForegroundColor: scheme.onSurfaceVariant,
      elevation: AppElevationTokens.level0,
      shadowColor: Colors.transparent,
      minimumSize: const Size(double.infinity, AppSizes.buttonHeightLg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      textStyle: AppTypography.buttonLarge,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // TEXT BUTTON
  // ─────────────────────────────────────────────────────────────────────────
  static TextButtonThemeData textButton({required ColorScheme scheme}) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: AppTypography.buttonSmall,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // OUTLINED BUTTON
  // ─────────────────────────────────────────────────────────────────────────
  static OutlinedButtonThemeData outlinedButton({
    required ColorScheme scheme,
  }) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: scheme.onSurface,
      side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
      minimumSize: const Size(double.infinity, AppSizes.buttonHeightLg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      textStyle: AppTypography.buttonMedium,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // INPUT DECORATION
  // ─────────────────────────────────────────────────────────────────────────
  static InputDecorationTheme inputDecoration({
    required ColorScheme scheme,
  }) => InputDecorationTheme(
    filled: true,
    fillColor: scheme.surfaceContainerHigh,
    prefixIconColor: scheme.onSurfaceVariant,
    suffixIconColor: scheme.onSurfaceVariant,
    hintStyle: AppTypography.inputHint.copyWith(color: scheme.onSurfaceVariant),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSizes.inputPaddingH,
      vertical: AppSizes.inputPaddingV,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(
        color: scheme.outline,
        width: AppSizes.borderWidth,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(
        color: scheme.outline,
        width: AppSizes.borderWidth,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(
        color: scheme.primary,
        width: AppSizes.borderWidthLg,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: scheme.error, width: AppSizes.borderWidth),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(
        color: scheme.error,
        width: AppSizes.borderWidthLg,
      ),
    ),
    errorStyle: AppTypography.inputError.copyWith(color: scheme.error),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // CARD
  // ─────────────────────────────────────────────────────────────────────────
  static CardThemeData card({required ColorScheme scheme}) => CardThemeData(
    color: scheme.surfaceContainer,
    surfaceTintColor: Colors.transparent,
    elevation: AppElevationTokens.card,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      side: BorderSide(
        color: scheme.outlineVariant,
        width: AppSizes.borderWidth,
      ),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // CHIP
  // ─────────────────────────────────────────────────────────────────────────
  static ChipThemeData chip({required ColorScheme scheme}) => ChipThemeData(
    backgroundColor: scheme.surfaceContainerHigh,
    selectedColor: scheme.primaryContainer,
    disabledColor: scheme.surfaceContainerHighest,
    labelStyle: AppTypography.chipLabel.copyWith(
      color: scheme.onSurfaceVariant,
    ),
    secondaryLabelStyle: AppTypography.chipLabel.copyWith(
      color: scheme.primary,
    ),
    side: BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.chipRadiusFull),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.chipPaddingH,
      vertical: AppSizes.chipPaddingV,
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // BOTTOM NAVIGATION BAR
  // ─────────────────────────────────────────────────────────────────────────
  static BottomNavigationBarThemeData bottomNavigationBar({
    required ColorScheme scheme,
  }) => BottomNavigationBarThemeData(
    backgroundColor: scheme.surface,
    selectedItemColor: scheme.primary,
    unselectedItemColor: scheme.onSurfaceVariant,
    selectedLabelStyle: AppTypography.navLabelSelected,
    unselectedLabelStyle: AppTypography.navLabelUnselected,
    elevation: AppElevationTokens.level0,
    type: BottomNavigationBarType.fixed,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // NAVIGATION BAR (Material 3)
  // ─────────────────────────────────────────────────────────────────────────
  static NavigationBarThemeData navigationBar({required ColorScheme scheme}) =>
      NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onPrimaryContainer);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.navLabelSelected.copyWith(
              color: scheme.onSurface,
            );
          }
          return AppTypography.navLabelUnselected.copyWith(
            color: scheme.onSurfaceVariant,
          );
        }),
        elevation: AppElevationTokens.level0,
        height: AppSizes.bottomNavHeightMd,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // FLOATING ACTION BUTTON
  // ─────────────────────────────────────────────────────────────────────────
  static FloatingActionButtonThemeData fab({required ColorScheme scheme}) =>
      FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: AppElevationTokens.level0,
        focusElevation: AppElevationTokens.level0,
        hoverElevation: AppElevationTokens.level0,
        highlightElevation: AppElevationTokens.level0,
        iconSize: AppSizes.fabIconSize,
        shape: const CircleBorder(),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // DIALOG
  // ─────────────────────────────────────────────────────────────────────────
  static DialogThemeData dialog({required ColorScheme scheme}) =>
      DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevationTokens.dialog,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          side: BorderSide(
            color: scheme.outlineVariant,
            width: AppSizes.borderWidth,
          ),
        ),
        titleTextStyle: AppTypography.dialogTitle.copyWith(
          color: scheme.onSurface,
        ),
        contentTextStyle: AppTypography.dialogContent.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // DRAWER
  // ─────────────────────────────────────────────────────────────────────────
  static DrawerThemeData drawer({required ColorScheme scheme}) =>
      DrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevationTokens.drawer,
        width: AppSizes.drawerWidthMd,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSizes.radiusXl),
            bottomRight: Radius.circular(AppSizes.radiusXl),
          ),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────────────────
  static BottomSheetThemeData bottomSheet({required ColorScheme scheme}) =>
      BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevationTokens.bottomSheet,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.bottomSheetRadiusMd),
          ),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // SNACK BAR
  // ─────────────────────────────────────────────────────────────────────────
  static SnackBarThemeData snackBar({required ColorScheme scheme}) =>
      SnackBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: AppTypography.snackBarContent.copyWith(
          color: scheme.onSurface,
        ),
        actionTextColor: scheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          side: BorderSide(
            color: scheme.outlineVariant,
            width: AppSizes.borderWidth,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.snackbarPaddingH,
          vertical: AppSizes.spaceSm,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // LIST TILE
  // ─────────────────────────────────────────────────────────────────────────
  static ListTileThemeData listTile({required ColorScheme scheme}) =>
      const ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.listTilePaddingH,
          vertical: AppSizes.listTilePaddingV,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // DIVIDER
  // ─────────────────────────────────────────────────────────────────────────
  static DividerThemeData divider({required ColorScheme scheme}) =>
      DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppSizes.dividerThickness,
        indent: AppSizes.dividerIndent,
        endIndent: AppSizes.dividerIndent,
        space: 0,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // SWITCH
  // ─────────────────────────────────────────────────────────────────────────
  static SwitchThemeData switchTheme({required ColorScheme scheme}) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.surfaceContainerHigh;
        }),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // CHECKBOX
  // ─────────────────────────────────────────────────────────────────────────
  static CheckboxThemeData checkbox({required ColorScheme scheme}) =>
      CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: scheme.outline, width: AppSizes.borderWidthMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // PROGRESS INDICATOR
  // ─────────────────────────────────────────────────────────────────────────
  static ProgressIndicatorThemeData progressIndicator({
    required ColorScheme scheme,
  }) => ProgressIndicatorThemeData(
    color: scheme.primary,
    linearTrackColor: scheme.primaryContainer,
    circularTrackColor: scheme.primaryContainer,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // TAB BAR
  // ─────────────────────────────────────────────────────────────────────────
  static TabBarThemeData tabBar({required ColorScheme scheme}) =>
      TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        dividerColor: scheme.outlineVariant,
        labelStyle: AppTypography.tabSelected,
        unselectedLabelStyle: AppTypography.tabUnselected,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // TOOLTIP
  // ─────────────────────────────────────────────────────────────────────────
  static TooltipThemeData tooltip({required ColorScheme scheme}) =>
      TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        textStyle: AppTypography.tooltip.copyWith(
          color: scheme.onInverseSurface,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // RADIO
  // ─────────────────────────────────────────────────────────────────────────
  static RadioThemeData radio({required ColorScheme scheme}) => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return scheme.primary;
      return scheme.outline;
    }),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // SLIDER
  // ─────────────────────────────────────────────────────────────────────────
  static SliderThemeData slider({required ColorScheme scheme}) =>
      SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.surfaceContainerHigh,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: AppSizes.opacitySubtle),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // BADGE
  // ─────────────────────────────────────────────────────────────────────────
  static BadgeThemeData badge({required ColorScheme scheme}) => BadgeThemeData(
    backgroundColor: scheme.error,
    textColor: scheme.onError,
    textStyle: AppTypography.badge,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────────────────────────────────
  static SearchBarThemeData searchBar({required ColorScheme scheme}) =>
      SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
        elevation: const WidgetStatePropertyAll(0),
        side: WidgetStatePropertyAll(
          BorderSide(color: scheme.outline, width: AppSizes.borderWidth),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // DATE PICKER
  // ─────────────────────────────────────────────────────────────────────────
  static DatePickerThemeData datePicker({required ColorScheme scheme}) =>
      DatePickerThemeData(
        backgroundColor: scheme.surface,
        headerBackgroundColor: scheme.primaryContainer,
        headerForegroundColor: scheme.onPrimaryContainer,
        dayStyle: AppTypography.datePickerDay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // TIME PICKER
  // ─────────────────────────────────────────────────────────────────────────
  static TimePickerThemeData timePicker({required ColorScheme scheme}) =>
      TimePickerThemeData(
        backgroundColor: scheme.surface,
        hourMinuteColor: scheme.surfaceContainerHigh,
        hourMinuteTextColor: scheme.onSurface,
        dialBackgroundColor: scheme.surfaceContainerHigh,
        dialHandColor: scheme.primary,
        dialTextColor: scheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // POPUP MENU
  // ─────────────────────────────────────────────────────────────────────────
  static PopupMenuThemeData popupMenu({required ColorScheme scheme}) =>
      PopupMenuThemeData(
        color: scheme.surfaceContainer,
        elevation: AppElevationTokens.menu,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        textStyle: AppTypography.popupMenuItem.copyWith(
          color: scheme.onSurface,
        ),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // EXPANSION TILE
  // ─────────────────────────────────────────────────────────────────────────
  static ExpansionTileThemeData expansionTile({required ColorScheme scheme}) =>
      ExpansionTileThemeData(
        backgroundColor: scheme.surfaceContainer,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: scheme.primary,
        collapsedIconColor: scheme.onSurfaceVariant,
        textColor: scheme.primary,
        collapsedTextColor: scheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      );
}
