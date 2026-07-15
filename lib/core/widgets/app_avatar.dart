import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/localization/generated/l10n.dart';
import '../../features/chat/presentation/widgets/chat_page/attachment_picker_sheet.dart';
import '../theme/app_sizes.dart';

/// Reusable profile picture widget with optional image picker.
///
/// Usage:
/// ```dart
/// // Read-only
/// AppAvatar(imageUrl: user.picture, name: user.name)
///
/// // Editable with loading
/// AppAvatar(
///   imageUrl: user.picture,
///   name: user.name,
///   size: AppSizes.avatarXl,
///   editable: true,
///   isLoading: authState.isLoading(AuthAction.updatePicture),
///   onImagePicked: (file) => cubit.updatePicture(file),
/// )
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.localImage,
    this.name,
    this.size,
    this.editable = false,
    this.isLoading = false,
    this.onImagePicked,
  }) : assert(
         !editable || onImagePicked != null,
         'onImagePicked must be provided when editable is true',
       );

  final String? imageUrl;
  final File? localImage;
  final String? name;
  final double? size;
  final bool editable;
  final bool isLoading;
  final ValueChanged<File>? onImagePicked;

  double get _size => size ?? AppSizes.avatarXl;

  // ── First letter of first name + first letter of last name ──────────────
  String get _initials {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  Future<void> _pickImage(BuildContext context) async {
    if (isLoading) return;
    AttachmentPickerSheet.show(
      cameraLabel: S.of(context).takePhoto,
      galleryLabel: S.of(context).chooseFromGallery,

      context,
      onSelected: (source) async {
        final picker = ImagePicker();
        XFile? picked;
        if (source == AttachmentSource.camera) {
          picked = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          );
        } else if (source == AttachmentSource.gallery) {
          picked = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
        }
        if (picked == null) return;
        onImagePicked?.call(File(picked.path));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaledSize = _size.r;
    final iconSize = (scaledSize * 0.18).clamp(14.0, 24.0);

    return GestureDetector(
      onTap: editable ? () => _pickImage(context) : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Avatar ───────────────────────────────────────────────
          _buildAvatar(colorScheme, scaledSize),

          // ── Loading overlay ──────────────────────────────────────
          if (isLoading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface.withValues(alpha: 0.65),
                ),
                child: Center(
                  child: SizedBox(
                    width: scaledSize * 0.4,
                    height: scaledSize * 0.4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

          // ── Edit badge — hidden while loading ────────────────────
          if (editable && !isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: iconSize * 1.9,
                height: iconSize * 1.9,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: iconSize,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme, double scaledSize) {
    // ── Initials fallback — used when no image or on error ───────────────
    final fallback = CircleAvatar(
      radius: scaledSize / 2,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: (scaledSize * 0.32).clamp(12.0, 36.0),
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );

    // ── Local file (just picked) — highest priority ───────────────────────
    if (localImage != null) {
      return CircleAvatar(
        radius: scaledSize / 2,
        backgroundColor: colorScheme.primaryContainer,
        backgroundImage: FileImage(localImage!),
      );
    }

    // ── Remote URL — with loading, error, and offline handling ───────────
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: scaledSize / 2,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, _) => CircleAvatar(
          radius: scaledSize / 2,
          backgroundColor: colorScheme.primaryContainer,
          child: SizedBox(
            width: scaledSize * 0.4,
            height: scaledSize * 0.4,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
        ),
        // ── Offline or broken URL → show initials instead of broken icon ─
        errorWidget: (context, _, _) => fallback,
      );
    }

    // ── No image at all → initials ────────────────────────────────────────
    return fallback;
  }
}
