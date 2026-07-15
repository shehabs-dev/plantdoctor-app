import 'package:flutter/material.dart';

import '../design_system.dart';

/// Semantic color tokens beyond Material 3's built-in roles.
///
/// Reads from [AppConfig] directly — no changes needed here when rebranding.
///
/// Access in widgets:
/// ```dart
/// final ext = Theme.of(context).extension<AppThemeExtension>()!;
/// Container(color: ext.successContainer)
/// ```
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.onSurfaceDim,
  });

  // ── Success ─────────────────────────────────────────────────────
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  // ── Warning ─────────────────────────────────────────────────────
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  // ── Info ────────────────────────────────────────────────────────
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // ── Dim text (third text level below onSurface + onSurfaceVariant)
  final Color onSurfaceDim;

  // ─────────────────────────────────────────────────────────────────
  // PRESETS — built from AppConfig, no hardcoded values here
  // ─────────────────────────────────────────────────────────────────

  static const AppThemeExtension dark = AppThemeExtension(
    success: AppConfig.successDark,
    onSuccess: Color(0xFFFFFFFF),
    successContainer: AppConfig.successContainerDark,
    onSuccessContainer: AppConfig.successContainerLight,

    warning: AppConfig.warningDark,
    onWarning: Color(0xFFFFFFFF),
    warningContainer: AppConfig.warningContainerDark,
    onWarningContainer: AppConfig.warningContainerLight,

    info: AppConfig.infoDark,
    onInfo: Color(0xFFFFFFFF),
    infoContainer: AppConfig.infoContainerDark,
    onInfoContainer: AppConfig.infoContainerLight,

    onSurfaceDim: AppConfig.darkOnSurfaceDim,
  );

  static const AppThemeExtension light = AppThemeExtension(
    success: AppConfig.successLight,
    onSuccess: Color(0xFFFFFFFF),
    successContainer: AppConfig.successContainerLight,
    onSuccessContainer: AppConfig.successLight,

    warning: AppConfig.warningLight,
    onWarning: Color(0xFFFFFFFF),
    warningContainer: AppConfig.warningContainerLight,
    onWarningContainer: AppConfig.warningLight,

    info: AppConfig.infoLight,
    onInfo: Color(0xFFFFFFFF),
    infoContainer: AppConfig.infoContainerLight,
    onInfoContainer: AppConfig.infoLight,

    onSurfaceDim: AppConfig.lightOnSurfaceDim,
  );

  // ─────────────────────────────────────────────────────────────────
  // ThemeExtension API
  // ─────────────────────────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? onSurfaceDim,
  }) => AppThemeExtension(
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
    infoContainer: infoContainer ?? this.infoContainer,
    onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    onSurfaceDim: onSurfaceDim ?? this.onSurfaceDim,
  );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      onSurfaceDim: Color.lerp(onSurfaceDim, other.onSurfaceDim, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeExtension &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          onSuccess == other.onSuccess &&
          successContainer == other.successContainer &&
          onSuccessContainer == other.onSuccessContainer &&
          warning == other.warning &&
          onWarning == other.onWarning &&
          warningContainer == other.warningContainer &&
          onWarningContainer == other.onWarningContainer &&
          info == other.info &&
          onInfo == other.onInfo &&
          infoContainer == other.infoContainer &&
          onInfoContainer == other.onInfoContainer &&
          onSurfaceDim == other.onSurfaceDim;

  @override
  int get hashCode => Object.hash(
    success,
    onSuccess,
    successContainer,
    onSuccessContainer,
    warning,
    onWarning,
    warningContainer,
    onWarningContainer,
    info,
    onInfo,
    infoContainer,
    onInfoContainer,
    onSurfaceDim,
  );
}
