import 'package:flutter/material.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../core/theme/app_sizes.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LocationPermissionDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      icon: Icon(
        Icons.location_on_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: AppSizes.iconXxl,
      ),
      title: Text(
        S.of(context).locationPermissionTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        S.of(context).locationPermissionMessage,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(S.of(context).allowLocation),
        ),
      ],
    );
  }
}
