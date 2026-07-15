import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../domain/entities/message_entity.dart';

class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({super.key, required this.message, this.localImage});

  final MessageEntity message;
  final File? localImage;

  bool get _hasImage =>
      message.imageURL != null ||
      (localImage?.existsSync() ?? false) ||
      (message.localImagePath != null &&
          File(message.localImagePath!).existsSync());

  bool get _hasText =>
      message.prompt != null && message.prompt!.trim().isNotEmpty;

  File? _getEffectiveLocalFile() {
    if (localImage?.existsSync() ?? false) return localImage;
    if (message.localImagePath != null) {
      final file = File(message.localImagePath!);
      if (file.existsSync()) return file;
    }
    return null;
  }

  TextDirection _detectDirection(String text) {
    final rtlRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF]');
    return rtlRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  // ── Border radius helpers ──────────────────────────────────────────────────
  // Top corners are always rounded. Bottom-end is sharp (chat tail).
  // When image + text: image gets square bottom corners so text sits flush.

  BorderRadiusGeometry get _radiusImageOnly => BorderRadiusDirectional.only(
    topStart: Radius.circular(AppSizes.radiusLg.r),
    topEnd: Radius.circular(AppSizes.radiusLg.r),
    bottomStart: Radius.circular(AppSizes.radiusLg.r),
    bottomEnd: Radius.circular(AppSizes.radiusSm.r),
  );

  BorderRadiusGeometry get _radiusTextOnly => BorderRadiusDirectional.only(
    topStart: Radius.circular(AppSizes.radiusLg.r),
    topEnd: Radius.circular(AppSizes.radiusLg.r),
    bottomStart: Radius.circular(AppSizes.radiusLg.r),
    bottomEnd: Radius.circular(AppSizes.radiusSm.r),
  );

  BorderRadiusGeometry get _radiusBothOuter => BorderRadiusDirectional.only(
    topStart: Radius.circular(AppSizes.radiusLg.r),
    topEnd: Radius.circular(AppSizes.radiusLg.r),
    bottomStart: Radius.circular(AppSizes.radiusLg.r),
    bottomEnd: Radius.circular(AppSizes.radiusSm.r),
  );

  // Image clip inside the combined bubble — square bottom so text sits flush
  BorderRadius get _radiusImageTop => BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusLg.r),
    topRight: Radius.circular(AppSizes.radiusLg.r),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localFile = _getEffectiveLocalFile();

    // Bubble color:
    //   Light → theme.colorScheme.primary (deep forest green #1E7A36)
    //   Dark  → primaryContainer (deep dark green #1A3A24) — calm on dark bg
    // To adjust the dark color, change AppConfig.primaryContainerDark.
    final bubbleColor = isDark
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.primary;

    final textColor = isDark
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onPrimary;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Container(
          margin: EdgeInsetsDirectional.only(
            start: 48.w,
            end: 12.w,
            top: 4.h,
            bottom: 4.h,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: _hasImage && _hasText
                ? _radiusBothOuter
                : _hasImage
                ? _radiusImageOnly
                : _radiusTextOnly,
          ),
          clipBehavior: Clip.antiAlias,
          child: _hasImage && _hasText
              ? _buildImageWithText(theme, localFile, textColor, bubbleColor)
              : _hasImage
              ? _buildImageOnly(theme, localFile)
              : _buildTextOnly(theme, textColor),
        ),
      ),
    );
  }

  // ── Image + text ────────────────────────────────────────────────────────

  Widget _buildImageWithText(
    ThemeData theme,
    File? localFile,
    Color textColor,
    Color bubbleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image — clipped only on top corners so it merges into bubble body
        ClipRRect(
          borderRadius: _radiusImageTop,
          child: _buildImage(theme, localFile),
        ),

        // Subtle divider between image and text
        Divider(
          height: 1,
          thickness: AppSizes.borderWidthSm,
          color: textColor.withValues(alpha: 0.15),
        ),

        // Text
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMd.w,
            vertical: AppSizes.spaceXs.h,
          ),
          child: Directionality(
            textDirection: _detectDirection(message.prompt!),
            child: SelectableText(
              message.prompt!,
              textAlign: TextAlign.start,
              selectionColor: textColor.withValues(alpha: 0.35),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: AppSizes.lineHeightMd,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Image only ──────────────────────────────────────────────────────────

  Widget _buildImageOnly(ThemeData theme, File? localFile) {
    return _buildImage(theme, localFile);
  }

  // ── Text only ───────────────────────────────────────────────────────────

  Widget _buildTextOnly(ThemeData theme, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd.w,
        vertical: AppSizes.spaceXs.h,
      ),
      child: Directionality(
        textDirection: _detectDirection(message.prompt!),
        child: SelectableText(
          message.prompt!,
          textAlign: TextAlign.start,
          selectionColor: textColor.withValues(alpha: 0.35),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            height: AppSizes.lineHeightMd,
          ),
        ),
      ),
    );
  }

  // ── Shared image widget ─────────────────────────────────────────────────

  Widget _buildImage(ThemeData theme, File? localFile) {
    const imageHeight = 200.0;

    if (localFile != null) {
      return Image.file(
        localFile,
        fit: BoxFit.cover,
        width: double.infinity,
        height: imageHeight.h,
      );
    }

    if (message.imageURL != null) {
      return CachedNetworkImage(
        imageUrl: message.imageURL!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: imageHeight.h,
        placeholder: (context, url) => SizedBox(
          height: imageHeight.h,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _brokenImage(theme, imageHeight),
      );
    }

    return _brokenImage(theme, imageHeight);
  }

  Widget _brokenImage(ThemeData theme, double height) {
    return SizedBox(
      height: height.h,
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: AppSizes.iconXl.r,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
