import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AttachmentSource { camera, gallery, files }

class AttachmentPickerSheet extends StatelessWidget {
  const AttachmentPickerSheet({
    super.key,
    required this.onSelected,
    this.title,
    this.showCamera = true,
    this.showGallery = true,
    this.showFiles = false,
    this.cameraLabel = 'Take Photo',
    this.galleryLabel = 'Choose from Gallery',
    this.filesLabel = 'Choose File',
    this.cameraIcon = Icons.camera_alt_outlined,
    this.galleryIcon = Icons.photo_library_outlined,
    this.filesIcon = Icons.insert_drive_file_outlined,
    this.padding,
  });

  final ValueChanged<AttachmentSource> onSelected;

  final String? title;
  final bool showCamera;
  final bool showGallery;
  final bool showFiles;

  final String cameraLabel;
  final String galleryLabel;
  final String filesLabel;

  final IconData cameraIcon;
  final IconData galleryIcon;
  final IconData filesIcon;

  final EdgeInsetsGeometry? padding;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<AttachmentSource> onSelected,
    String? title,
    bool showCamera = true,
    bool showGallery = true,
    bool showFiles = false,
    String cameraLabel = 'Take Photo',
    String galleryLabel = 'Choose from Gallery',
    String filesLabel = 'Choose File',
    IconData cameraIcon = Icons.camera_alt_outlined,
    IconData galleryIcon = Icons.photo_library_outlined,
    IconData filesIcon = Icons.insert_drive_file_outlined,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AttachmentPickerSheet(
          onSelected: onSelected,
          title: title,
          showCamera: showCamera,
          showGallery: showGallery,
          showFiles: showFiles,
          cameraLabel: cameraLabel,
          galleryLabel: galleryLabel,
          filesLabel: filesLabel,
          cameraIcon: cameraIcon,
          galleryIcon: galleryIcon,
          filesIcon: filesIcon,
          padding: padding,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      child: Material(
        color:
            theme.bottomSheetTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: theme.bottomSheetTheme.elevation ?? 6,
        borderRadius: BorderRadius.circular(28.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),
              if (title != null) ...[
                SizedBox(height: 10.h),
                Text(
                  title!,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
              ] else
                SizedBox(height: 8.h),
              if (showCamera)
                _AttachmentOptionTile(
                  icon: cameraIcon,
                  label: cameraLabel,
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(AttachmentSource.camera);
                  },
                ),
              if (showGallery)
                _AttachmentOptionTile(
                  icon: galleryIcon,
                  label: galleryLabel,
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(AttachmentSource.gallery);
                  },
                ),
              if (showFiles)
                _AttachmentOptionTile(
                  icon: filesIcon,
                  label: filesLabel,
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(AttachmentSource.files);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentOptionTile extends StatelessWidget {
  const _AttachmentOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.onSurface),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 42.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }
}
