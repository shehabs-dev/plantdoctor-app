import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../network_system/presentation/cubit/connectivity/connectivity_cubit.dart';
import '../cubit/report_cubit.dart';

class ReportPendingBanner extends StatefulWidget {
  const ReportPendingBanner({super.key, required this.userId});

  final String userId;

  @override
  State<ReportPendingBanner> createState() => _ReportPendingBannerState();
}

class _ReportPendingBannerState extends State<ReportPendingBanner> {
  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().loadPendingReports(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ── Auto-sync when connectivity is restored ───────────────────────
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listenWhen: (prev, curr) =>
              prev is! ConnectivityOnline && curr is ConnectivityOnline,
          listener: (context, _) {
            context.read<ReportCubit>().syncPendingReports(widget.userId);
          },
        ),
        // ── Show snackbar on sync failure ─────────────────────────────────
        BlocListener<ReportCubit, ReportState>(
          listenWhen: (_, curr) => curr is ReportSyncFailed,
          listener: (context, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).syncFailedOffline),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<ReportCubit, ReportState>(
        // Rebuild on any state that affects the banner's appearance.
        // ReportSyncing  → show spinner
        // ReportSyncFailed → quickly replaced by PendingReportsLoaded
        // PendingReportsLoaded → main content
        // ReportLoading(loadingPending) → hide until loaded
        buildWhen: (_, curr) =>
            curr is PendingReportsLoaded ||
            curr is ReportSyncing ||
            curr is ReportSyncFailed ||
            curr is ReportLoading,
        builder: (context, state) {
          // Keep banner visible during sync — only hide when genuinely no data.
          final reports = switch (state) {
            PendingReportsLoaded() => state.reports,
            ReportSyncing() => const <dynamic>[], // spinner replaces list
            _ => null,
          };

          // null means we don't have data yet — hide.
          if (reports == null) return const SizedBox.shrink();

          // After sync completes with empty list — hide banner.
          if (state is PendingReportsLoaded && state.reports.isEmpty) {
            return const SizedBox.shrink();
          }

          final isSyncing = state is ReportSyncing;
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMd.w,
                  vertical: AppSizes.spaceSm.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusLg.r),
                    topRight: Radius.circular(AppSizes.radiusLg.r),
                    bottomLeft: Radius.circular(
                      isSyncing
                          ? 0
                          : (reports.isEmpty ? AppSizes.radiusLg.r : 0),
                    ),
                    bottomRight: Radius.circular(
                      isSyncing
                          ? 0
                          : (reports.isEmpty ? AppSizes.radiusLg.r : 0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pending_outlined,
                      color: colorScheme.onTertiaryContainer,
                      size: AppSizes.iconSm.r,
                    ),
                    SizedBox(width: AppSizes.spaceXs.w),
                    Text(
                      isSyncing
                          ? S.of(context).syncingReports
                          : S
                                .of(context)
                                .pendingReports(
                                  (state as PendingReportsLoaded)
                                      .reports
                                      .length,
                                ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    // ── Sync button / spinner ──────────────────────────
                    if (isSyncing)
                      SizedBox(
                        width: AppSizes.iconSm.r,
                        height: AppSizes.iconSm.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onTertiaryContainer,
                        ),
                      )
                    else
                      FilledButton.icon(
                        onPressed: () => context
                            .read<ReportCubit>()
                            .syncPendingReports(widget.userId),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.onTertiaryContainer
                              .withValues(alpha: 0.15),
                          foregroundColor: colorScheme.onTertiaryContainer,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceSm.w,
                            vertical: 4.h,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: theme.textTheme.labelSmall,
                        ),
                        icon: Icon(
                          Icons.cloud_upload_outlined,
                          size: AppSizes.iconXs.r,
                        ),
                        label: Text(S.of(context).syncNow),
                      ),
                  ],
                ),
              ),

              // ── Pending report tiles (hidden while syncing) ──────────────
              if (!isSyncing && reports.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.radiusLg.r),
                      bottomRight: Radius.circular(AppSizes.radiusLg.r),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return _PendingReportTile(report: report);
                    },
                  ),
                ),

              SizedBox(height: AppSizes.spaceMd.h),
            ],
          );
        },
      ),
    );
  }
}

// ── Single pending report tile ──────────────────────────────────────────────

class _PendingReportTile extends StatelessWidget {
  const _PendingReportTile({required this.report});

  final dynamic report; // ReportEntity

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ── Resolve image — local path takes priority over URL ────────────────
    Widget? imageWidget;
    if (report.imagePath != null) {
      final file = File(report.imagePath as String);
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm.r),
        child: Image.file(
          file,
          width: 48.r,
          height: 48.r,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _imagePlaceholder(colorScheme),
        ),
      );
    } else if (report.imageURL != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm.r),
        child: Image.network(
          report.imageURL as String,
          width: 48.r,
          height: 48.r,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _imagePlaceholder(colorScheme),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd.w,
        vertical: AppSizes.spaceSm.h,
      ),
      child: Row(
        children: [
          // ── Image or placeholder ──────────────────────────────────
          if (imageWidget != null) ...[
            imageWidget,
            SizedBox(width: AppSizes.spaceSm.w),
          ] else ...[
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm.r),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: AppSizes.iconSm.r,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(width: AppSizes.spaceSm.w),
          ],

          // ── Description + date ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.description as String,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  _formatDate(report.reportDate as DateTime),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // ── Pending indicator ─────────────────────────────────────
          SizedBox(width: AppSizes.spaceXs.w),
          Icon(
            Icons.schedule_rounded,
            size: AppSizes.iconSm.r,
            color: colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      color: colorScheme.outline.withValues(alpha: 0.15),
      child: Icon(
        Icons.broken_image_outlined,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
