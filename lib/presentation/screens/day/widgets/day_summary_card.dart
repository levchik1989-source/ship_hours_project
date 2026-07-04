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
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(context, localizations.regularHours, calculation.regularHours.toStringAsFixed(1)),
            _row(context, localizations.overtimeHours, calculation.overtimeHours.toStringAsFixed(1)),
            _row(context, localizations.totalHours, calculation.totalHours.toStringAsFixed(1)),
            const Divider(),
            _row(context, localizations.regularPay, MoneyFormatter.format(amount: calculation.regularPay, currency: settings.currency)),
            _row(context, localizations.overtimePay, MoneyFormatter.format(amount: calculation.overtimePay, currency: settings.currency)),
            _row(context, localizations.totalPay, MoneyFormatter.format(amount: calculation.totalPay, currency: settings.currency)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
