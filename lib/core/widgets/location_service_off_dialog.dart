import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../core/theme/app_sizes.dart';

class LocationServiceOffDialog extends StatelessWidget {
  const LocationServiceOffDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LocationServiceOffDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      icon: Icon(
        Icons.location_off_rounded,
        color: Theme.of(context).colorScheme.error,
        size: AppSizes.iconXxl,
      ),
      title: Text(
        S.of(context).locationServiceOffTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        S.of(context).locationServiceOffMessage,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Geolocator.openLocationSettings();
          },
          child: Text(S.of(context).openSettings),
        ),
      ],
    );
  }
}
