import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class MonthHeader extends StatelessWidget {
  const MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final title = DateFormat.yMMMM(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(month);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          IconButton(onPressed: onPrevious, icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}
