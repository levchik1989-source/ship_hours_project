import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/utils/month_utils.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/day_record.dart';
import '../../../../domain/services/company_rules_service.dart';
import '../../../../domain/services/hours_calculator.dart';

final class CalendarDayTile extends StatelessWidget {
  const CalendarDayTile({
    required this.date,
    required this.month,
    required this.record,
    required this.settings,
    super.key,
  });

  final DateTime date;
  final DateTime month;
  final DayRecord? record;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = MonthUtils.isCurrentMonth(day: date, month: month);
    final workedHours = record?.totalHours ?? 0;
    final calculation = record == null
        ? null
        : HoursCalculator.calculate(record: record!, settings: settings);

    final scheme = Theme.of(context).colorScheme;
    final isWeekend = CompanyRulesService.isWeekend(date);
    final isObservedHoliday =
        CompanyRulesService.isObservedHoliday(date, settings) && !isWeekend;
    final accent =
        _accentColor(calculation, isWeekend, isObservedHoliday, scheme);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: isCurrentMonth
          ? () {
              Navigator.of(context).pushNamed(AppRouter.day, arguments: date);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isObservedHoliday
              ? const Color(0xFFD84315).withOpacity(0.25)
              : isWeekend
                  ? const Color(0xFF263238).withOpacity(0.55)
                  : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accent.withOpacity(
              workedHours > 0 || isObservedHoliday ? 0.9 : 0.18,
            ),
            width: workedHours > 0 || isObservedHoliday ? 1.3 : 1,
          ),
        ),
        child: Opacity(
          opacity: isCurrentMonth ? 1 : 0.35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                _StatusDots(calculation: calculation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(
    HoursCalculationResult? calculation,
    bool isWeekend,
    bool isObservedHoliday,
    ColorScheme scheme,
  ) {
    if (isObservedHoliday || (calculation?.holidayHours ?? 0) > 0) {
      return const Color(0xFFD84315);
    }
    if ((calculation?.overtimeHours ?? 0) > 0) {
      return const Color(0xFFFFA000);
    }
    if ((calculation?.regularHours ?? 0) > 0) {
      return const Color(0xFF2E7D32);
    }
    if (isWeekend) return const Color(0xFF546E7A);
    return scheme.outlineVariant;
  }
}

final class _StatusDots extends StatelessWidget {
  const _StatusDots({required this.calculation});

  final HoursCalculationResult? calculation;

  @override
  Widget build(BuildContext context) {
    final dots = <Color>[
      if ((calculation?.regularHours ?? 0) > 0) const Color(0xFF2E7D32),
      if ((calculation?.overtimeHours ?? 0) > 0) const Color(0xFFFFA000),
      if ((calculation?.holidayHours ?? 0) > 0) const Color(0xFFD84315),
    ];

    if (dots.isEmpty) return const SizedBox(height: 4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final color in dots)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
