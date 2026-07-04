import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/calendar_controller.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/month_header.dart';

final class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final controller = context.watch<CalendarController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calendar),
        actions: [
          IconButton(
            tooltip: localizations.statistics,
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRouter.statistics,
                arguments: controller.selectedMonth,
              );
            },
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            tooltip: localizations.settings,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settings);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                MonthHeader(
                  month: controller.selectedMonth,
                  onPrevious: controller.previousMonth,
                  onNext: controller.nextMonth,
                ),
                Expanded(
                  child: CalendarGrid(
                    month: controller.selectedMonth,
                    records: controller.records,
                  ),
                ),
              ],
            ),
    );
  }
}
