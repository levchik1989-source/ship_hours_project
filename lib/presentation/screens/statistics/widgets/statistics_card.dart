import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/month_statistics.dart';
import '../../../../l10n/app_localizations.dart';

final class StatisticsCard extends StatelessWidget {
  const StatisticsCard({required this.statistics, required this.settings, super.key});

  final MonthStatistics statistics;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.salary, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _highlight(context, l.totalPay, MoneyFormatter.format(amount: statistics.totalPay, currency: settings.currency)),
            const SizedBox(height: 12),
            _row(context, l.totalHours, '${statistics.totalHours.toStringAsFixed(1)}h'),
            _row(context, l.regularHours, '${statistics.regularHours.toStringAsFixed(1)}h'),
            _row(context, l.overtimeHours, '${statistics.overtimeHours.toStringAsFixed(1)}h'),
            _row(context, l.fixedOvertimeDeduction, '-${statistics.fixedOvertimeHours.toStringAsFixed(1)}h'),
            _row(context, l.paidOvertime, '${statistics.paidOvertimeHours.toStringAsFixed(1)}h'),
            _row(context, l.holidayHours, '${statistics.holidayHours.toStringAsFixed(1)}h'),
            const Divider(height: 24),
            _row(context, l.baseSalary, MoneyFormatter.format(amount: statistics.baseSalary, currency: settings.currency)),
            _row(context, l.regularPay, MoneyFormatter.format(amount: statistics.regularPay, currency: settings.currency)),
            _row(context, l.overtimePay, MoneyFormatter.format(amount: statistics.overtimePay, currency: settings.currency)),
            _row(context, l.holidayPay, MoneyFormatter.format(amount: statistics.holidayPay, currency: settings.currency)),
          ],
        ),
      ),
    );
  }

  Widget _highlight(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF14B8A6)]),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70))),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
