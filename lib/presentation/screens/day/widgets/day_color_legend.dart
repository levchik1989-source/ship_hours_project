import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

final class DayColorLegend extends StatelessWidget {
  const DayColorLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Wrap(
          spacing: 10,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _LegendItem(color: const Color(0xFF2E7D32), label: l.regularShort),
            _LegendItem(color: const Color(0xFFFFA000), label: l.overtimeShort),
            _LegendItem(color: const Color(0xFFD84315), label: l.holidayShort),
            _LegendItem(color: Theme.of(context).colorScheme.surfaceContainerHighest, label: l.emptyShort),
          ],
        ),
      ),
    );
  }
}

final class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
