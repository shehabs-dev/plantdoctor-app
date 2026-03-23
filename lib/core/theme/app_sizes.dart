import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Universal app sizes — reusable across any Flutter application.
///
/// Two tiers:
/// ─────────────────────────────────────────────────────────────
/// RAW (const)   → used in ThemeData only — no ScreenUtil dependency
/// SCALED        → used in widgets only — requires ScreenUtil to be ready
///
/// Rules for scaled getters:
/// - .r  → uniform scale (radius, icons, avatars, square containers)
/// - .w  → horizontal scale (widths, horizontal padding)
/// - .h  → vertical scale (heights, vertical padding, spacing)
/// - .sp → font scale only (text — respects OS accessibility settings)
///
/// ⚠️  Icons use .r NOT .sp — icons don't follow text scale.
/// ⚠️  Never use scaled getters in ThemeData or global variables.
///     Only use them inside build() methods after ScreenUtilInit.

class AppSizes {
  AppSizes._();

  // ════════════════════════════════════════════════════════════════
  // RAW CONSTANTS — used in ThemeData only, no ScreenUtil
  // ════════════════════════════════════════════════════════════════

  // ── BORDER RADIUS ─────────────────────────────
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusXxl = 32;
  static const double radiusFull = 100;

  // ── BORDER WIDTH ──────────────────────────────
  static const double borderWidthSm = 0.5;
  static const double borderWidth = 1;
  static const double borderWidthMd = 1.5;
  static const double borderWidthLg = 2;

  // ── FONT SIZES ────────────────────────────────
  static const double fontXxs = 9;
  static const double fontXs = 10;
  static const double fontSm = 11;
  static const double fontMd = 13;
  static const double fontLg = 15;
  static const double fontXl = 17;
  static const double fontXxl = 20;
  static const double font3xl = 24;
  static const double font4xl = 28;

  // ── ICON SIZES ────────────────────────────────
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconXxl = 40;

  // ── ICON BUTTON ───────────────────────────────
  static const double iconBtnSizeSm = 32;
  static const double iconBtnSizeMd = 40;
  static const double iconBtnSizeLg = 48;

  // ── BUTTON ────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // ── INPUT FIELD ───────────────────────────────
  static const double inputHeightSm = 44;
  static const double inputHeightMd = 52;
  static const double inputHeightLg = 60;
  static const double inputPaddingH = 16;
  static const double inputPaddingV = 14;

  // ── SPACING ───────────────────────────────────
  static const double spaceXxs = 4;
  static const double spaceXs = 8;
  static const double spaceSm = 12;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;
  static const double space3xl = 64;

  // ── SCREEN PADDING ────────────────────────────
  static const double screenPaddingH = 24;
  static const double screenPaddingV = 20;
  static const double screenPaddingHSm = 16;

  // ── APP BAR ───────────────────────────────────
  static const double appBarHeightSm = 52;
  static const double appBarHeightMd = 56;
  static const double appBarHeightLg = 64;
  static const double appBarIconSize = 24;
  static const double appBarIconBtnSize = 40;

  // ── AVATAR ────────────────────────────────────
  static const double avatarXs = 24;
  static const double avatarSm = 32;
  static const double avatarMd = 44;
  static const double avatarLg = 56;
  static const double avatarXl = 72;
  static const double avatarXxl = 96;

  // ── BADGE ─────────────────────────────────────
  static const double badgeSizeSm = 6;
  static const double badgeSizeMd = 8;
  static const double badgeSizeLg = 18;

  // ── CHIP / TAG ────────────────────────────────
  static const double chipHeightSm = 24;
  static const double chipHeightMd = 32;
  static const double chipPaddingH = 10;
  static const double chipPaddingV = 4;
  static const double chipRadiusSm = 6;
  static const double chipRadiusMd = 12;
  static const double chipRadiusFull = 100;

  // ── DIVIDER ───────────────────────────────────
  static const double dividerThickness = 1;
  static const double dividerThicknessMd = 1.5;
  static const double dividerIndent = 16;

  // ── DRAWER ────────────────────────────────────
  static const double drawerWidthSm = 240;
  static const double drawerWidthMd = 280;
  static const double drawerWidthLg = 320;

  // ── BOTTOM SHEET ──────────────────────────────
  static const double bottomSheetRadiusSm = 16;
  static const double bottomSheetRadiusMd = 24;
  static const double bottomSheetHandleWidth = 40;
  static const double bottomSheetHandleHeight = 4;

  // ── BOTTOM NAV ────────────────────────────────
  static const double bottomNavHeightSm = 60;
  static const double bottomNavHeightMd = 72;
  static const double bottomNavIconSize = 24;

  // ── LIST ITEM ─────────────────────────────────
  static const double listItemHeightSm = 48;
  static const double listItemHeightMd = 64;
  static const double listItemHeightLg = 80;

  // ── LIST TILE ─────────────────────────────────
  static const double listTilePaddingH = 24;
  static const double listTilePaddingV = 4;

  // ── IMAGE / THUMBNAIL ─────────────────────────
  static const double thumbSm = 40;
  static const double thumbMd = 56;
  static const double thumbLg = 80;
  static const double thumbXl = 120;

  // ── FLOATING ACTION BUTTON ────────────────────
  static const double fabSizeSm = 40;
  static const double fabSizeMd = 52;
  static const double fabSizeLg = 64;
  static const double fabIconSize = 24;

  // ── DIALOG ────────────────────────────────────
  static const double dialogPaddingH = 24;
  static const double dialogPaddingV = 20;

  // ── SNACKBAR ──────────────────────────────────
  static const double snackbarHeightSm = 48;
  static const double snackbarHeightMd = 56;
  static const double snackbarPaddingH = 16;

  // ── PROGRESS INDICATOR ────────────────────────
  static const double progressHeightSm = 2;
  static const double progressHeightMd = 4;
  static const double progressHeightLg = 6;
  static const double progressCircleSm = 16;
  static const double progressCircleMd = 24;
  static const double progressCircleLg = 40;

  // ── SKELETON / SHIMMER ────────────────────────
  static const double skeletonHeightSm = 12;
  static const double skeletonHeightMd = 16;
  static const double skeletonHeightLg = 20;
  static const double skeletonRadius = 6;

  // ── CHECKBOX / RADIO ──────────────────────────
  static const double checkboxSize = 20;
  static const double radioSize = 20;

  // ── LINE HEIGHT — never device-dependent ──────
  static const double lineHeightSm = 1.4;
  static const double lineHeightMd = 1.6;
  static const double lineHeightLg = 1.8;

  // ── OPACITY — never device-dependent ──────────
  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.5;
  static const double opacityOverlay = 0.6;
  static const double opacitySubtle = 0.08;

  // ════════════════════════════════════════════════════════════════
  // SCALED GETTERS — use ONLY inside build() after ScreenUtilInit
  // Single source of truth: scaled links back to raw constant above
  // ════════════════════════════════════════════════════════════════

  // ── BORDER RADIUS — .r ────────────────────────
  static double get radiusXsScaled => radiusXs.r;
  static double get radiusSmScaled => radiusSm.r;
  static double get radiusMdScaled => radiusMd.r;
  static double get radiusLgScaled => radiusLg.r;
  static double get radiusXlScaled => radiusXl.r;
  static double get radiusXxlScaled => radiusXxl.r;
  static double get radiusFullScaled => radiusFull.r;

  // ── BORDER WIDTH — .r ─────────────────────────
  static double get borderWidthSmScaled => borderWidthSm.r;
  static double get borderWidthScaled => borderWidth.r;
  static double get borderWidthMdScaled => borderWidthMd.r;
  static double get borderWidthLgScaled => borderWidthLg.r;

  // ── SPACING — .h ──────────────────────────────
  static double get spaceXxsScaled => spaceXxs.h;
  static double get spaceXsScaled => spaceXs.h;
  static double get spaceSmScaled => spaceSm.h;
  static double get spaceMdScaled => spaceMd.h;
  static double get spaceLgScaled => spaceLg.h;
  static double get spaceXlScaled => spaceXl.h;
  static double get spaceXxlScaled => spaceXxl.h;
  static double get space3xlScaled => space3xl.h;

  // ── SCREEN PADDING ────────────────────────────
  static double get screenPaddingHScaled => screenPaddingH.w;
  static double get screenPaddingVScaled => screenPaddingV.h;
  static double get screenPaddingHSmScaled => screenPaddingHSm.w;

  // ── FONT SIZES — .sp ──────────────────────────
  static double get fontXxsScaled => fontXxs.sp;
  static double get fontXsScaled => fontXs.sp;
  static double get fontSmScaled => fontSm.sp;
  static double get fontMdScaled => fontMd.sp;
  static double get fontLgScaled => fontLg.sp;
  static double get fontXlScaled => fontXl.sp;
  static double get fontXxlScaled => fontXxl.sp;
  static double get font3xlScaled => font3xl.sp;
  static double get font4xlScaled => font4xl.sp;

  // ── ICON SIZES — .r NOT .sp ───────────────────
  static double get iconXsScaled => iconXs.r;
  static double get iconSmScaled => iconSm.r;
  static double get iconMdScaled => iconMd.r;
  static double get iconLgScaled => iconLg.r;
  static double get iconXlScaled => iconXl.r;
  static double get iconXxlScaled => iconXxl.r;

  // ── ICON BUTTON — .r ──────────────────────────
  static double get iconBtnSizeSmScaled => iconBtnSizeSm.r;
  static double get iconBtnSizeMdScaled => iconBtnSizeMd.r;
  static double get iconBtnSizeLgScaled => iconBtnSizeLg.r;

  // ── BUTTON — .h ───────────────────────────────
  static double get buttonHeightSmScaled => buttonHeightSm.h;
  static double get buttonHeightMdScaled => buttonHeightMd.h;
  static double get buttonHeightLgScaled => buttonHeightLg.h;

  // ── INPUT FIELD ───────────────────────────────
  static double get inputHeightSmScaled => inputHeightSm.h;
  static double get inputHeightMdScaled => inputHeightMd.h;
  static double get inputHeightLgScaled => inputHeightLg.h;
  static double get inputPaddingHScaled => inputPaddingH.w;
  static double get inputPaddingVScaled => inputPaddingV.h;

  // ── CARD PADDING ──────────────────────────────
  static double get cardPaddingHSmScaled => 12.w;
  static double get cardPaddingHMdScaled => 16.w;
  static double get cardPaddingHLgScaled => 20.w;
  static double get cardPaddingVSmScaled => 10.h;
  static double get cardPaddingVMdScaled => 14.h;
  static double get cardPaddingVLgScaled => 18.h;

  // ── APP BAR ───────────────────────────────────
  static double get appBarHeightSmScaled => appBarHeightSm.h;
  static double get appBarHeightMdScaled => appBarHeightMd.h;
  static double get appBarHeightLgScaled => appBarHeightLg.h;
  static double get appBarIconSizeScaled => appBarIconSize.r;
  static double get appBarIconBtnSizeScaled => appBarIconBtnSize.r;

  // ── AVATAR — .r ───────────────────────────────
  static double get avatarXsScaled => avatarXs.r;
  static double get avatarSmScaled => avatarSm.r;
  static double get avatarMdScaled => avatarMd.r;
  static double get avatarLgScaled => avatarLg.r;
  static double get avatarXlScaled => avatarXl.r;
  static double get avatarXxlScaled => avatarXxl.r;

  // ── BADGE — .r ────────────────────────────────
  static double get badgeSizeSmScaled => badgeSizeSm.r;
  static double get badgeSizeMdScaled => badgeSizeMd.r;
  static double get badgeSizeLgScaled => badgeSizeLg.r;

  // ── CHIP ──────────────────────────────────────
  static double get chipHeightSmScaled => chipHeightSm.h;
  static double get chipHeightMdScaled => chipHeightMd.h;
  static double get chipPaddingHScaled => chipPaddingH.w;
  static double get chipPaddingVScaled => chipPaddingV.h;
  static double get chipRadiusSmScaled => chipRadiusSm.r;
  static double get chipRadiusMdScaled => chipRadiusMd.r;
  static double get chipRadiusFullScaled => chipRadiusFull.r;

  // ── DIVIDER ───────────────────────────────────
  static double get dividerThicknessScaled => dividerThickness.h;
  static double get dividerThicknessMdScaled => dividerThicknessMd.h;
  static double get dividerIndentScaled => dividerIndent.w;

  // ── DRAWER ────────────────────────────────────
  static double get drawerWidthSmScaled => drawerWidthSm.w;
  static double get drawerWidthMdScaled => drawerWidthMd.w;
  static double get drawerWidthLgScaled => drawerWidthLg.w;

  // ── BOTTOM SHEET ──────────────────────────────
  static double get bottomSheetRadiusSmScaled => bottomSheetRadiusSm.r;
  static double get bottomSheetRadiusMdScaled => bottomSheetRadiusMd.r;
  static double get bottomSheetHandleWidthScaled => bottomSheetHandleWidth.w;
  static double get bottomSheetHandleHeightScaled => bottomSheetHandleHeight.h;

  // ── BOTTOM NAV ────────────────────────────────
  static double get bottomNavHeightSmScaled => bottomNavHeightSm.h;
  static double get bottomNavHeightMdScaled => bottomNavHeightMd.h;
  static double get bottomNavIconSizeScaled => bottomNavIconSize.r;

  // ── LIST ITEM ─────────────────────────────────
  static double get listItemHeightSmScaled => listItemHeightSm.h;
  static double get listItemHeightMdScaled => listItemHeightMd.h;
  static double get listItemHeightLgScaled => listItemHeightLg.h;

  // ── IMAGE / THUMBNAIL — .r ────────────────────
  static double get thumbSmScaled => thumbSm.r;
  static double get thumbMdScaled => thumbMd.r;
  static double get thumbLgScaled => thumbLg.r;
  static double get thumbXlScaled => thumbXl.r;

  // ── FAB — .r ──────────────────────────────────
  static double get fabSizeSmScaled => fabSizeSm.r;
  static double get fabSizeMdScaled => fabSizeMd.r;
  static double get fabSizeLgScaled => fabSizeLg.r;
  static double get fabIconSizeScaled => fabIconSize.r;

  // ── DIALOG ────────────────────────────────────
  static double get dialogWidthSmScaled => 0.75.sw;
  static double get dialogWidthMdScaled => 0.85.sw;
  static double get dialogWidthLgScaled => 0.95.sw;
  static double get dialogPaddingHScaled => dialogPaddingH.w;
  static double get dialogPaddingVScaled => dialogPaddingV.h;

  // ── SNACKBAR ──────────────────────────────────
  static double get snackbarHeightSmScaled => snackbarHeightSm.h;
  static double get snackbarHeightMdScaled => snackbarHeightMd.h;
  static double get snackbarPaddingHScaled => snackbarPaddingH.w;

  // ── PROGRESS INDICATOR ────────────────────────
  static double get progressHeightSmScaled => progressHeightSm.h;
  static double get progressHeightMdScaled => progressHeightMd.h;
  static double get progressHeightLgScaled => progressHeightLg.h;
  static double get progressCircleSmScaled => progressCircleSm.r;
  static double get progressCircleMdScaled => progressCircleMd.r;
  static double get progressCircleLgScaled => progressCircleLg.r;

  // ── SKELETON / SHIMMER ────────────────────────
  static double get skeletonHeightSmScaled => skeletonHeightSm.h;
  static double get skeletonHeightMdScaled => skeletonHeightMd.h;
  static double get skeletonHeightLgScaled => skeletonHeightLg.h;
  static double get skeletonRadiusScaled => skeletonRadius.r;

  // ── CHECKBOX / RADIO — .r ─────────────────────
  static double get checkboxSizeScaled => checkboxSize.r;
  static double get radioSizeScaled => radioSize.r;
}
