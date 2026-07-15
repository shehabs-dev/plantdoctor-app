import 'package:flutter/material.dart';
import '../../../../../config/localization/generated/l10n.dart';

class ComingSoonDialog {
  ComingSoonDialog._(); // prevent instantiation

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).micComingSoonTitle),
        content: Text(S.of(context).micComingSoonContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).micComingSoonAction),
          ),
        ],
      ),
    );
  }
}
