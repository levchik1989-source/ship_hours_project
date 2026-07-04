import 'package:flutter/material.dart';

import '../../../../core/utils/month_utils.dart';
import '../../../../domain/entities/day_record.dart';
import 'calendar_day_tile.dart';

final class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.month,
    required this.records,
    super.key,
  });

  final DateTime month;
  final List<DayRecord> records;

  @override
  Widget build(BuildContext context) {
    final days = MonthUtils.calendarDays(month);

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        return CalendarDayTile(date: day, month: month, record: _recordFor(day));
      },
    );
  }

  DayRecord? _recordFor(DateTime date) {
    for (final record in records) {
      if (record.date.year == date.year && record.date.month == date.month && record.date.day == date.day) {
        return record;
      }
    }
    return null;
  }
}
