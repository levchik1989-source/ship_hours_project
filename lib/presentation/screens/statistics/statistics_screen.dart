import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/services/statistics_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import '../../controllers/calendar_controller.dart';
import 'widgets/export_card.dart';
import 'widgets/statistics_card.dart';

final class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({required this.selectedMonth, super.key});

  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final settings = context.watch<AppSettingsController>().settings;
    final calendarController = context.watch<CalendarController>();
    final statistics = StatisticsCalculator.calculate(records: calendarController.records, settings: settings);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.statistics)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          StatisticsCard(statistics: statistics, settings: settings),
          const SizedBox(height: 12),
          ExportCard(statistics: statistics, settings: settings, month: selectedMonth),
        ],
      ),
    );
  }
}
