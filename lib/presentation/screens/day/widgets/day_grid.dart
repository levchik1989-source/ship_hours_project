import 'package:flutter/material.dart';

import '../../../../domain/services/hours_calculator.dart';
import 'hour_row.dart';

final class DayGrid extends StatelessWidget {
  const DayGrid({
    required this.slotCategories,
    required this.onSlotTap,
    super.key,
  });

  final List<WorkSlotCategory> slotCategories;
  final ValueChanged<int> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _HourColumn(startHour: 0, slotCategories: slotCategories, onSlotTap: onSlotTap)),
          const SizedBox(width: 8),
          Expanded(child: _HourColumn(startHour: 12, slotCategories: slotCategories, onSlotTap: onSlotTap)),
        ],
      ),
    );
  }
}

final class _HourColumn extends StatelessWidget {
  const _HourColumn({
    required this.startHour,
    required this.slotCategories,
    required this.onSlotTap,
  });

  final int startHour;
  final List<WorkSlotCategory> slotCategories;
  final ValueChanged<int> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28, right: 2, bottom: 2),
          child: Row(
            children: [
              Expanded(child: Text(':00', textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall)),
              const SizedBox(width: 3),
              Expanded(child: Text(':30', textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall)),
            ],
          ),
        ),
        for (var hour = startHour; hour < startHour + 12; hour++)
          HourRow(
            hour: hour,
            firstCategory: slotCategories[hour * 2],
            secondCategory: slotCategories[hour * 2 + 1],
            onFirstTap: () => onSlotTap(hour * 2),
            onSecondTap: () => onSlotTap(hour * 2 + 1),
          ),
      ],
    );
  }
}
