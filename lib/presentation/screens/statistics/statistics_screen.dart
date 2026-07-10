import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_router.dart';
import '../../../domain/services/statistics_calculator.dart';
import '../../../domain/services/profile_salary_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../controllers/salary_profile_controller.dart';
import 'widgets/export_card.dart';
import 'widgets/statistics_card.dart';

final class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    required this.selectedMonth,
    super.key,
  });

  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final settings = context.watch<AppSettingsController>().settings;
    final calendarController = context.watch<CalendarController>();
    final activeProfile =
        context.watch<SalaryProfileController>().activeProfile;

    final monthRecords = calendarController.records.where((record) {
      return record.date.year == selectedMonth.year &&
          record.date.month == selectedMonth.month;
    }).toList();

    final statistics = StatisticsCalculator.calculate(
      records: monthRecords,
      settings: settings,
    );

    final salaryCalculation = activeProfile == null
        ? null
        : ProfileSalaryCalculator.calculate(
            records: monthRecords,
            settings: settings,
            profile: activeProfile,
        travelAllowance: calendarController.travelAllowance,
        canteenDeduction: calendarController.canteenDeduction,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.statistics),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 1,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.calendar);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          StatisticsCard(
            statistics: statistics,
            settings: settings,
            salaryCalculation: salaryCalculation,
          ),
          const SizedBox(height: 12),
          ExportCard(
            statistics: statistics,
            settings: settings,
            month: selectedMonth,
          ),
        ],
      ),
    );
  }
}
