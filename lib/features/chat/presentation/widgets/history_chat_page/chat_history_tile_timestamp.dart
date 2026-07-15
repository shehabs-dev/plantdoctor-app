import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../config/localization/generated/l10n.dart';

class ChatHistoryTileTimestamp extends StatelessWidget {
  const ChatHistoryTileTimestamp({super.key, required this.dateTime});

  final DateTime dateTime;

  String _format(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return DateFormat.jm(locale).format(dateTime);
    } else if (date == yesterday) {
      return S.of(context).yesterday;
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat.EEEE(locale).format(dateTime);
    } else {
      return DateFormat.yMMMd(locale).format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_format(context), style: Theme.of(context).textTheme.bodySmall);
  }
}
