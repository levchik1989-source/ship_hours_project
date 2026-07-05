import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/repositories/work_hours_repository.dart';
import '../../../domain/services/hours_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../controllers/day_controller.dart';
import 'widgets/day_summary_card.dart';
import 'widgets/day_grid.dart';

final class DayScreen extends StatelessWidget {
  const DayScreen({required this.selectedDate, super.key});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DayController>(
      create: (context) => DayController(
        repository: context.read<WorkHoursRepository>(),
        selectedDate: selectedDate,
      )..load(),
      child: const _DayScreenContent(),
    );
  }
}

final class _DayScreenContent extends StatelessWidget {
  const _DayScreenContent();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final controller = context.watch<DayController>();
    final settings = context.watch<AppSettingsController>().settings;
    final record = controller.record;

    final calculation = record == null
        ? null
        : HoursCalculator.calculate(record: record, settings: settings);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.day),
        actions: [
          IconButton(
            tooltip: localizations.clearDay,
            onPressed: () async {
              await controller.clearDay();
              if (context.mounted) {
                await context.read<CalendarController>().refresh();
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: controller.isLoading || record == null || calculation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DaySummaryCard(calculation: calculation, settings: settings),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: DayGrid(
                          slotCategories: calculation.slotCategories,
                          onSlotTap: (index) async {
                            await controller.toggleSlot(index);
                            if (context.mounted) {
                              await context
                                  .read<CalendarController>()
                                  .refresh();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
