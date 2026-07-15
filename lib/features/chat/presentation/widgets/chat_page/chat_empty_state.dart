import 'package:flutter/material.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco_rounded,
              size: AppSizes.iconXxl,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            SizedBox(height: AppSizes.spaceMd),
            Text(
              S.of(context).chatEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: AppSizes.spaceXs),
            Text(
              S.of(context).chatEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
