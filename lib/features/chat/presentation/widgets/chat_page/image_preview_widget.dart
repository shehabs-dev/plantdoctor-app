// image_preview_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_sizes.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({
    super.key,
    required this.image,
    required this.onRemove,
  });

  final File image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: Row(
        children: [
          Stack(
            children: [
              // ── Image ────────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.file(
                  image,
                  width: 80.r,
                  height: 80.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 80.r,
                    height: 80.r,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              // ── Remove button ────────────────────────────────────────
              Positioned(
                top: 4.r,
                right: 4.r,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 13.r,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
