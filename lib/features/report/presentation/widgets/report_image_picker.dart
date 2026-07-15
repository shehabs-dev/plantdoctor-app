import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';

class ReportImagePicker extends StatelessWidget {
  const ReportImagePicker({
    super.key,
    required this.selectedImage,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  final File? selectedImage;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (selectedImage != null) {
      return _ImagePreview(image: selectedImage!, onRemove: onRemove);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).attachImage,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: AppSizes.spaceXs.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickCamera,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(S.of(context).camera),
              ),
            ),
            SizedBox(width: AppSizes.spaceSm.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(S.of(context).gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.image, required this.onRemove});

  final File image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).attachedImage,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: AppSizes.spaceXs.h),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
              child: Image.file(
                image,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8.r,
              right: 8.r,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: AppSizes.iconSm.r,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
