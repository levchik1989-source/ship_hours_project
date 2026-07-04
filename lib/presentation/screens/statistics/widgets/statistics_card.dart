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
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(context, localizations.regularHours, statistics.regularHours.toStringAsFixed(1)),
            _row(context, localizations.overtimeHours, statistics.overtimeHours.toStringAsFixed(1)),
            _row(context, localizations.totalHours, statistics.totalHours.toStringAsFixed(1)),
            const Divider(),
            _row(context, localizations.regularPay, MoneyFormatter.format(amount: statistics.regularPay, currency: settings.currency)),
            _row(context, localizations.overtimePay, MoneyFormatter.format(amount: statistics.overtimePay, currency: settings.currency)),
            _row(context, localizations.totalPay, MoneyFormatter.format(amount: statistics.totalPay, currency: settings.currency)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
