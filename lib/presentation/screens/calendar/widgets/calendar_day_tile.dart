import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/utils/month_utils.dart';
import '../../../../domain/entities/day_record.dart';

final class CalendarDayTile extends StatelessWidget {
  const CalendarDayTile({
    required this.date,
    required this.month,
    required this.record,
    super.key,
  });

  final DateTime date;
  final DateTime month;
  final DayRecord? record;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = MonthUtils.isCurrentMonth(day: date, month: month);
    final workedHours = record?.totalHours ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isCurrentMonth
          ? () {
              Navigator.of(context).pushNamed(AppRouter.day, arguments: date);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: workedHours > 0 ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Opacity(
          opacity: isCurrentMonth ? 1 : 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date.day.toString(), style: Theme.of(context).textTheme.labelLarge),
              if (workedHours > 0) Text('${workedHours.toStringAsFixed(1)}h', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
