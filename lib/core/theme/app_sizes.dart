import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Universal app sizes — raw constants and ScreenUtil-scaled getters.
///
/// TWO TIERS — use the right one:
/// ─────────────────────────────────────────────────────────────────
/// RAW (const double)   → ThemeData, StyleSheet, any place evaluated
///                        before ScreenUtil initialises.
///
/// SCALED (get → .r/w/h/sp) → inside Widget build() methods only,
///                             after [ScreenUtilInit] has run.
///
/// Scale rules:
///   .r  → uniform (radius, icons, avatars, square containers)
///   .w  → horizontal (widths, horizontal padding)
///   .h  → vertical (heights, vertical padding, spacing)
///   .sp → font scale (respects OS accessibility)
///
/// ⚠️  Icons use .r — icons must NOT follow text scale.
/// ⚠️  Never use scaled getters in ThemeData or top-level variables.
abstract final class AppSizes {
  // ══════════════════════════════════════════════════════════════════
  // RAW CONSTANTS
  // ══════════════════════════════════════════════════════════════════

  // ── Spacing scale ─────────────────────────────────────────────
  // xs=4  sm=8  md=16  lg=24  xl=32
  // (These are the "semantic" names used everywhere in UI)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double x3l = 64;

  // ── Aliases for intermediate values ───────────────────────────
  // Keeps existing code working without a big rename wave.
  // Prefer the semantic names above in new code.
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;
  static const double space3xl = 64;

  // ── Border radius ─────────────────────────────────────────────
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusXxl = 32;
  static const double radiusFull = 100;

  // ── Border width ──────────────────────────────────────────────
  static const double borderWidthSm = 0.5;
  static const double borderWidth = 1.0;
  static const double borderWidthMd = 1.5;
  static const double borderWidthLg = 2.0;

  // ── Font sizes ────────────────────────────────────────────────
  static const double fontXxs = 9;
  static const double fontXs = 10;
  static const double fontSm = 11;
  static const double fontMd = 13;
  static const double fontLg = 15;
  static const double fontXl = 17;
  static const double fontXxl = 20;
  static const double font3xl = 24;
  static const double font4xl = 28;

  // ── Line heights ──────────────────────────────────────────────
  static const double lineHeightSm = 1.4;
  static const double lineHeightMd = 1.6;
  static const double lineHeightLg = 1.8;

  // ── Icon sizes ────────────────────────────────────────────────
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconXxl = 40;

  // ── Icon button sizes ─────────────────────────────────────────
  static const double iconBtnSm = 32;
  static const double iconBtnMd = 40;
  static const double iconBtnLg = 48;

  // ── Button heights ────────────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // ── Input field ───────────────────────────────────────────────
  static const double inputHeightSm = 44;
  static const double inputHeightMd = 52;
  static const double inputHeightLg = 60;
  static const double inputPaddingH = 16;
  static const double inputPaddingV = 14;

  // ── Screen padding ────────────────────────────────────────────
  static const double screenPaddingH = 24;
  static const double screenPaddingV = 20;
  static const double screenPaddingHSm = 16;

  // ── App bar ───────────────────────────────────────────────────
  static const double appBarHeightSm = 52;
  static const double appBarHeightMd = 56;
  static const double appBarHeightLg = 64;
  static const double appBarIconSize = 24;
  static const double appBarIconBtnSize = 40;

  // ── Avatar ────────────────────────────────────────────────────
  static const double avatarXs = 24;
  static const double avatarSm = 32;
  static const double avatarMd = 44;
  static const double avatarLg = 56;
  static const double avatarXl = 72;
  static const double avatarXxl = 96;

  // ── Badge ─────────────────────────────────────────────────────
  static const double badgeSm = 6;
  static const double badgeMd = 8;
  static const double badgeLg = 18;

  // ── Chip ──────────────────────────────────────────────────────
  static const double chipHeightSm = 24;
  static const double chipHeightMd = 32;
  static const double chipPaddingH = 10;
  static const double chipPaddingV = 4;
  static const double chipRadiusSm = 6;
  static const double chipRadiusMd = 12;
  static const double chipRadiusFull = 100;

  // ── Divider ───────────────────────────────────────────────────
  static const double dividerThickness = 1;
  static const double dividerThicknessMd = 1.5;
  static const double dividerIndent = 16;

  // ── Drawer ────────────────────────────────────────────────────
  static const double drawerWidthSm = 240;
  static const double drawerWidthMd = 280;
  static const double drawerWidthLg = 320;

  // ── Bottom sheet ──────────────────────────────────────────────
  static const double bottomSheetRadiusSm = 16;
  static const double bottomSheetRadiusMd = 24;
  static const double bottomSheetHandleWidth = 40;
  static const double bottomSheetHandleHeight = 4;

  // ── Bottom nav ────────────────────────────────────────────────
  static const double bottomNavHeightSm = 60;
  static const double bottomNavHeightMd = 72;
  static const double bottomNavIconSize = 24;

  // ── List ──────────────────────────────────────────────────────
  static const double listItemHeightSm = 48;
  static const double listItemHeightMd = 64;
  static const double listItemHeightLg = 80;
  static const double listTilePaddingH = 24;
  static const double listTilePaddingV = 4;

  // ── Thumbnail ─────────────────────────────────────────────────
  static const double thumbSm = 40;
  static const double thumbMd = 56;
  static const double thumbLg = 80;
  static const double thumbXl = 120;

  // ── FAB ───────────────────────────────────────────────────────
  static const double fabSizeSm = 40;
  static const double fabSizeMd = 52;
  static const double fabSizeLg = 64;
  static const double fabIconSize = 24;

  // ── Dialog ────────────────────────────────────────────────────
  static const double dialogPaddingH = 24;
  static const double dialogPaddingV = 20;

  // ── Snackbar ──────────────────────────────────────────────────
  static const double snackbarHeightSm = 48;
  static const double snackbarHeightMd = 56;
  static const double snackbarPaddingH = 16;

  // ── Progress indicator ────────────────────────────────────────
  static const double progressHeightSm = 2;
  static const double progressHeightMd = 4;
  static const double progressHeightLg = 6;
  static const double progressCircleSm = 16;
  static const double progressCircleMd = 24;
  static const double progressCircleLg = 40;

  // ── Skeleton / shimmer ────────────────────────────────────────
  static const double skeletonHeightSm = 12;
  static const double skeletonHeightMd = 16;
  static const double skeletonHeightLg = 20;
  static const double skeletonRadius = 6;

  // ── Form controls ─────────────────────────────────────────────
  static const double checkboxSize = 20;
  static const double radioSize = 20;

  // ── Opacity ───────────────────────────────────────────────────
  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.5;
  static const double opacityOverlay = 0.6;
  static const double opacitySubtle = 0.08;

  // ══════════════════════════════════════════════════════════════════
  // SCALED GETTERS — use ONLY inside build() after ScreenUtilInit
  // Single source of truth: each getter links back to its raw const.
  // ══════════════════════════════════════════════════════════════════

  // ── Spacing scale ─────────────────────────────────────────────
  static double get xsScaled => xs.h;
  static double get smScaled => sm.h;
  static double get mdScaled => md.h;
  static double get lgScaled => lg.h;
  static double get xlScaled => xl.h;
  static double get xxlScaled => xxl.h;
  static double get x3lScaled => x3l.h;

  // ── Intermediate spacing (backward compat) ────────────────────
  static double get spaceXxsScaled => spaceXxs.h;
  static double get spaceXsScaled => spaceXs.h;
  static double get spaceSmScaled => spaceSm.h;
  static double get spaceMdScaled => spaceMd.h;
  static double get spaceLgScaled => spaceLg.h;
  static double get spaceXlScaled => spaceXl.h;
  static double get spaceXxlScaled => spaceXxl.h;
  static double get space3xlScaled => space3xl.h;

  // ── Border radius ─────────────────────────────────────────────
  static double get radiusXsScaled => radiusXs.r;
  static double get radiusSmScaled => radiusSm.r;
  static double get radiusMdScaled => radiusMd.r;
  static double get radiusLgScaled => radiusLg.r;
  static double get radiusXlScaled => radiusXl.r;
  static double get radiusXxlScaled => radiusXxl.r;
  static double get radiusFullScaled => radiusFull.r;

  // ── Border width ──────────────────────────────────────────────
  static double get borderWidthSmScaled => borderWidthSm.r;
  static double get borderWidthScaled => borderWidth.r;
  static double get borderWidthMdScaled => borderWidthMd.r;
  static double get borderWidthLgScaled => borderWidthLg.r;

  // ── Font sizes ────────────────────────────────────────────────
  static double get fontXxsScaled => fontXxs.sp;
  static double get fontXsScaled => fontXs.sp;
  static double get fontSmScaled => fontSm.sp;
  static double get fontMdScaled => fontMd.sp;
  static double get fontLgScaled => fontLg.sp;
  static double get fontXlScaled => fontXl.sp;
  static double get fontXxlScaled => fontXxl.sp;
  static double get font3xlScaled => font3xl.sp;
  static double get font4xlScaled => font4xl.sp;

  // ── Icon sizes ────────────────────────────────────────────────
  static double get iconXsScaled => iconXs.r;
  static double get iconSmScaled => iconSm.r;
  static double get iconMdScaled => iconMd.r;
  static double get iconLgScaled => iconLg.r;
  static double get iconXlScaled => iconXl.r;
  static double get iconXxlScaled => iconXxl.r;

  // ── Icon button ───────────────────────────────────────────────
  static double get iconBtnSmScaled => iconBtnSm.r;
  static double get iconBtnMdScaled => iconBtnMd.r;
  static double get iconBtnLgScaled => iconBtnLg.r;

  // ── Button ────────────────────────────────────────────────────
  static double get buttonHeightSmScaled => buttonHeightSm.h;
  static double get buttonHeightMdScaled => buttonHeightMd.h;
  static double get buttonHeightLgScaled => buttonHeightLg.h;

  // ── Input ─────────────────────────────────────────────────────
  static double get inputHeightSmScaled => inputHeightSm.h;
  static double get inputHeightMdScaled => inputHeightMd.h;
  static double get inputHeightLgScaled => inputHeightLg.h;
  static double get inputPaddingHScaled => inputPaddingH.w;
  static double get inputPaddingVScaled => inputPaddingV.h;

  // ── Screen padding ────────────────────────────────────────────
  static double get screenPaddingHScaled => screenPaddingH.w;
  static double get screenPaddingVScaled => screenPaddingV.h;
  static double get screenPaddingHSmScaled => screenPaddingHSm.w;

  // ── App bar ───────────────────────────────────────────────────
  static double get appBarHeightSmScaled => appBarHeightSm.h;
  static double get appBarHeightMdScaled => appBarHeightMd.h;
  static double get appBarHeightLgScaled => appBarHeightLg.h;
  static double get appBarIconSizeScaled => appBarIconSize.r;
  static double get appBarIconBtnSizeScaled => appBarIconBtnSize.r;

  // ── Avatar ────────────────────────────────────────────────────
  static double get avatarXsScaled => avatarXs.r;
  static double get avatarSmScaled => avatarSm.r;
  static double get avatarMdScaled => avatarMd.r;
  static double get avatarLgScaled => avatarLg.r;
  static double get avatarXlScaled => avatarXl.r;
  static double get avatarXxlScaled => avatarXxl.r;

  // ── Chip ──────────────────────────────────────────────────────
  static double get chipHeightSmScaled => chipHeightSm.h;
  static double get chipHeightMdScaled => chipHeightMd.h;
  static double get chipPaddingHScaled => chipPaddingH.w;
  static double get chipPaddingVScaled => chipPaddingV.h;
  static double get chipRadiusSmScaled => chipRadiusSm.r;
  static double get chipRadiusMdScaled => chipRadiusMd.r;
  static double get chipRadiusFullScaled => chipRadiusFull.r;

  // ── Drawer ────────────────────────────────────────────────────
  static double get drawerWidthSmScaled => drawerWidthSm.w;
  static double get drawerWidthMdScaled => drawerWidthMd.w;
  static double get drawerWidthLgScaled => drawerWidthLg.w;

  // ── Dialog ────────────────────────────────────────────────────
  static double get dialogWidthSmScaled => 0.75.sw;
  static double get dialogWidthMdScaled => 0.85.sw;
  static double get dialogWidthLgScaled => 0.95.sw;
  static double get dialogPaddingHScaled => dialogPaddingH.w;
  static double get dialogPaddingVScaled => dialogPaddingV.h;

  // ── Thumbnail ─────────────────────────────────────────────────
  static double get thumbSmScaled => thumbSm.r;
  static double get thumbMdScaled => thumbMd.r;
  static double get thumbLgScaled => thumbLg.r;
  static double get thumbXlScaled => thumbXl.r;

  // ── FAB ───────────────────────────────────────────────────────
  static double get fabSizeSmScaled => fabSizeSm.r;
  static double get fabSizeMdScaled => fabSizeMd.r;
  static double get fabSizeLgScaled => fabSizeLg.r;
  static double get fabIconSizeScaled => fabIconSize.r;

  // ── Progress indicator ────────────────────────────────────────
  static double get progressHeightSmScaled => progressHeightSm.h;
  static double get progressHeightMdScaled => progressHeightMd.h;
  static double get progressHeightLgScaled => progressHeightLg.h;
  static double get progressCircleSmScaled => progressCircleSm.r;
  static double get progressCircleMdScaled => progressCircleMd.r;
  static double get progressCircleLgScaled => progressCircleLg.r;

  // ── Skeleton ──────────────────────────────────────────────────
  static double get skeletonHeightSmScaled => skeletonHeightSm.h;
  static double get skeletonHeightMdScaled => skeletonHeightMd.h;
  static double get skeletonHeightLgScaled => skeletonHeightLg.h;
  static double get skeletonRadiusScaled => skeletonRadius.r;
}
