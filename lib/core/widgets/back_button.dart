import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';

class BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.iconBtnSizeMd, // 40.r
        height: AppSizes.iconBtnSizeMd, // 40.r
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm), // 8.r
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppSizes.iconSm, // 16.sp
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
