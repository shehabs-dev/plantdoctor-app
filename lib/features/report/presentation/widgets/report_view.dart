import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../config/di/injection_container.dart' as di;
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/helpers/error_message_key_x.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../network_system/presentation/cubit/connectivity/connectivity_cubit.dart';
import '../cubit/report_cubit.dart';
import 'report_image_picker.dart';
import 'report_pending_banner.dart';
import 'report_submit_button.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _descriptionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _userId() {
    final authState = di.sl<AuthCubit>().state;
    return authState is Authenticated ? authState.user.id ?? '' : '';
  }

  String _userName() {
    final authState = di.sl<AuthCubit>().state;
    return authState is Authenticated ? authState.user.name : '';
  }

  String _userEmail() {
    final authState = di.sl<AuthCubit>().state;
    return authState is Authenticated ? authState.user.email : '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    setState(() => _selectedImage = File(picked.path));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    context.read<ReportCubit>().submitReport(
      userId: _userId(),
      name: _userName(),
      email: _userEmail(),
      description: _descriptionController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      image: _selectedImage,
    );
  }

  void _reset() {
    _formKey.currentState?.reset();
    _descriptionController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() => _selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    final authState = di.sl<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;

    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.key.tr(context))));
        }
        if (state is ReportSubmitted) {
          _reset();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => _ReportSuccessDialog(isSynced: state.isSynced),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.isLoading(ReportAction.submitting);
        final isOnline =
            context.watch<ConnectivityCubit>().state is ConnectivityOnline;

        return CustomScrollView(
          slivers: [
            // ── App Bar ─────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: Text(S.of(context).report),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH.w,
                  vertical: AppSizes.spaceMd.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Pending reports banner ───────────────────
                      ReportPendingBanner(userId: _userId()),

                      SizedBox(height: AppSizes.spaceMd.h),

                      // ── User info card ───────────────────────────
                      _UserInfoCard(
                        name: user?.name ?? '',
                        email: user?.email ?? '',
                        imageUrl: user?.picture,
                      ),

                      SizedBox(height: AppSizes.spaceLg.h),

                      // ── Description ──────────────────────────────
                      AppTextFormField(
                        label: S.of(context).description,
                        fieldType: FieldType.description,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                      ),

                      SizedBox(height: AppSizes.spaceMd.h),

                      // ── Phone number ─────────────────────────────
                      AppTextFormField(
                        label: S.of(context).phoneNumber,
                        fieldType: FieldType.phone,
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: AppSizes.spaceMd.h),

                      // ── Address (optional) ────────────────────────
                      AppTextFormField(
                        label: S.of(context).address,
                        fieldType: FieldType.name,
                        controller: _addressController,
                        isRequired: false,
                        textInputAction: TextInputAction.done,
                        validator: (_) => null,
                      ),

                      SizedBox(height: AppSizes.spaceMd.h),

                      // ── Image picker ─────────────────────────────
                      ReportImagePicker(
                        selectedImage: _selectedImage,
                        onPickGallery: () => _pickImage(ImageSource.gallery),
                        onPickCamera: () => _pickImage(ImageSource.camera),
                        onRemove: () => setState(() => _selectedImage = null),
                      ),

                      SizedBox(height: AppSizes.spaceLg.h),

                      // ── Submit button ────────────────────────────
                      ReportSubmitButton(
                        isSubmitting: isSubmitting,
                        isOnline: isOnline,
                        onSubmit: _submit,
                      ),

                      SizedBox(height: AppSizes.spaceXxl.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Success dialog ─────────────────────────────────────────────────────────────

class _ReportSuccessDialog extends StatelessWidget {
  const _ReportSuccessDialog({required this.isSynced});

  final bool isSynced;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final color = isSynced ? colorScheme.primary : colorScheme.tertiary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spaceLg.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────────────────
            CircleAvatar(
              radius: 32.r,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                isSynced
                    ? Icons.check_circle_outline_rounded
                    : Icons.cloud_upload_outlined,
                color: color,
                size: AppSizes.iconLg.r,
              ),
            ),

            SizedBox(height: AppSizes.spaceMd.h),

            // ── Title ─────────────────────────────────────────────────
            Text(
              isSynced ? s.reportSubmittedTitle : s.reportSavedOfflineTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSizes.spaceXs.h),

            // ── Subtitle ──────────────────────────────────────────────
            Text(
              isSynced
                  ? s.reportSubmittedSubtitle
                  : s.reportSavedOfflineSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSizes.spaceLg.h),

            // ── Done button ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightLg.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: isSynced
                      ? colorScheme.onPrimary
                      : colorScheme.onTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(s.done),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── User info card ─────────────────────────────────────────────────────────────

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.name, required this.email, this.imageUrl});

  final String name;
  final String email;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.spaceMd.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
      ),
      child: Row(
        children: [
          AppAvatar(imageUrl: imageUrl, name: name, size: AppSizes.avatarMd),
          SizedBox(width: AppSizes.spaceMd.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                SizedBox(height: 2.h),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
