import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';

class ReportSubmitButton extends StatelessWidget {
  const ReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.isOnline,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final bool isOnline;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Offline notice ───────────────────────────────────────────
        if (!isOnline)
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.spaceXs.h),
            child: Row(
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: AppSizes.iconSm.r,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                SizedBox(width: 6.w),
                Text(
                  S.of(context).reportWillBeSavedOffline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

        // ── Button ───────────────────────────────────────────────────
        SizedBox(
          height: AppSizes.buttonHeightLg.h,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    isOnline
                        ? S.of(context).submitReport
                        : S.of(context).saveReport,
                  ),
          ),
        ),
      ],
    );
  }
}
