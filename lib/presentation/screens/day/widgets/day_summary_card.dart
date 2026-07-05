import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/services/hours_calculator.dart';
import '../../../../l10n/app_localizations.dart';

final class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({required this.calculation, required this.settings, super.key});

  final HoursCalculationResult calculation;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final note = calculation.isObservedHoliday && !calculation.isHoliday ? l.observedHoliday : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: _metric(context, l.totalHours, calculation.totalHours.toStringAsFixed(1), Icons.schedule)),
                const SizedBox(width: 8),
                Expanded(child: _metric(context, l.totalPay, MoneyFormatter.format(amount: calculation.totalPay, currency: settings.currency), Icons.payments_outlined)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _smallMetric(context, l.regularHours, calculation.regularHours, const Color(0xFF2E7D32))),
                Expanded(child: _smallMetric(context, l.overtimeHours, calculation.overtimeHours, const Color(0xFFFFA000))),
                Expanded(child: _smallMetric(context, l.holidayHours, calculation.holidayHours, const Color(0xFFD84315))),
              ],
            ),
            if (note != null) ...[
              const SizedBox(height: 6),
              Text(note, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: const Color(0xFFD84315))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.labelMedium)),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _smallMetric(BuildContext context, String title, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Flexible(child: Text('${value.toStringAsFixed(1)}h', style: Theme.of(context).textTheme.labelMedium)),
        ],
      ),
    );
  }
}
