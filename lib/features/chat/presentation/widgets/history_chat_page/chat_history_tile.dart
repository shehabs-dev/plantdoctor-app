import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../domain/entities/chat_entity.dart';
import 'chat_history_tile_timestamp.dart';

class ChatHistoryTile extends StatelessWidget {
  const ChatHistoryTile({
    super.key,
    required this.chat,
    this.isDeleting = false,
    this.onTap,
    this.onDelete,
  });

  final ChatEntity chat;
  final bool isDeleting;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onLongPress: isDeleting ? null : onDelete,
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
        child: InkWell(
          onTap: isDeleting ? null : onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMd.w,
              vertical: AppSizes.spaceMd.h,
            ),
            child: Row(
              children: [
                // ── Icon container ──────────────────────────────────
                Container(
                  width: AppSizes.avatarMd.r,
                  height: AppSizes.avatarMd.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd.r),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: AppSizes.iconMd.r,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: AppSizes.spaceMd.w),

                // ── Title + timestamp ───────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      ChatHistoryTileTimestamp(dateTime: chat.updatedAt),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.spaceXs.w),

                if (isDeleting)
                  SizedBox(
                    width: AppSizes.iconLg.r,
                    height: AppSizes.iconLg.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: colorScheme.primary,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppSizes.iconLg.r,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
