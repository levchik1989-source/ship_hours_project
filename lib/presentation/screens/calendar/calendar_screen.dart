import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_router.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../domain/services/statistics_calculator.dart';
import '../../../domain/services/profile_salary_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import '../../controllers/calendar_controller.dart';
import '../../controllers/salary_profile_controller.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/month_header.dart';

final class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final controller = context.watch<CalendarController>();
    final settings = context.watch<AppSettingsController>().settings;

    final statistics = StatisticsCalculator.calculate(
      records: controller.records,
      settings: settings,
    );

    final activeProfile =
        context.watch<SalaryProfileController>().activeProfile;

    final salaryCalculation = activeProfile == null
        ? null
        : ProfileSalaryCalculator.calculate(
            records: controller.records,
            settings: settings,
            profile: activeProfile,
            travelAllowance: controller.travelAllowance,
            canteenDeduction: controller.canteenDeduction,
          );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(localizations.calendar),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.of(context).pushReplacementNamed(
              AppRouter.statistics,
              arguments: controller.selectedMonth,
            );
          }
          if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _CalendarSummary(
                  statistics: statistics,
                  totalPay: salaryCalculation?.total ?? statistics.totalPay,
                  currency: settings.currency,
                ),
                _PayrollAdjustmentsCard(
                  travelAllowance: controller.travelAllowance,
                  canteenDeduction: controller.canteenDeduction,
                  currency: settings.currency,
                  onEdit: () => _showPayrollAdjustmentsDialog(
                    context,
                    controller,
                  ),
                ),
                MonthHeader(
                  month: controller.selectedMonth,
                  onPrevious: controller.previousMonth,
                  onNext: controller.nextMonth,
                ),
                Expanded(
                  child: CalendarGrid(
                    month: controller.selectedMonth,
                    records: controller.records,
                    settings: settings,
                  ),
                ),
              ],
            ),
    );
  }
}

final class _CalendarSummary extends StatelessWidget {
  const _CalendarSummary({
    required this.statistics,
    required this.totalPay,
    required this.currency,
  });

  final dynamic statistics;
  final double totalPay;
  final dynamic currency;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: l.totalHours,
                  value: '${statistics.totalHours.toStringAsFixed(1)}h',
                  icon: Icons.schedule_rounded,
                  accent: const Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: l.totalPay,
                  value: MoneyFormatter.format(
                    amount: totalPay,
                    currency: currency,
                  ),
                  icon: Icons.account_balance_wallet_outlined,
                  accent: const Color(0xFF00B7FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF071827),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    title: l.regularHours,
                    value: statistics.regularHours,
                    color: const Color(0xFF22C55E),
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    title: l.overtimeHours,
                    value: statistics.overtimeHours,
                    color: const Color(0xFFFF9800),
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    title: l.holidayHours,
                    value: statistics.holidayHours,
                    color: const Color(0xFFFF3B1F),
                  ),
                ),
                const Expanded(
                  child: _MiniStat(
                    title: 'Empty',
                    value: 0,
                    color: Color(0xFF374151),
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

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.28),
            const Color(0xFF071827),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
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

final class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}h',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

Future<void> _showPayrollAdjustmentsDialog(
  BuildContext context,
  CalendarController controller,
) async {
  final travelController = TextEditingController(
    text: controller.travelAllowance == 0
        ? ''
        : controller.travelAllowance.toStringAsFixed(2),
  );

  final canteenController = TextEditingController(
    text: controller.canteenDeduction == 0
        ? ''
        : controller.canteenDeduction.toStringAsFixed(2),
  );

  final shouldSave = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Payroll adjustments'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: travelController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Travel allowance',
                  helperText: 'Added to salary',
                  prefixIcon: Icon(
                    Icons.flight_takeoff_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: canteenController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Canteen deduction',
                  helperText: 'Deducted from salary',
                  prefixIcon: Icon(
                    Icons.restaurant_rounded,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  if (shouldSave == true) {
    double parseAmount(String value) {
      final normalized = value.trim().replaceAll(',', '.');

      return double.tryParse(normalized) ?? 0.0;
    }

    await controller.saveMonthAdjustments(
      travelAllowance: parseAmount(
        travelController.text,
      ),
      canteenDeduction: parseAmount(
        canteenController.text,
      ),
    );
  }

  travelController.dispose();
  canteenController.dispose();
}

final class _PayrollAdjustmentsCard extends StatelessWidget {
  const _PayrollAdjustmentsCard({
    required this.travelAllowance,
    required this.canteenDeduction,
    required this.currency,
    required this.onEdit,
  });

  final double travelAllowance;
  final double canteenDeduction;
  final dynamic currency;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        12,
      ),
      child: Material(
        color: const Color(0xFF071827),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              12,
              10,
              14,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Payroll adjustments',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_rounded,
                      ),
                    ),
                  ],
                ),
                _PayrollAdjustmentRow(
                  icon: Icons.flight_takeoff_rounded,
                  label: 'Travel allowance',
                  sign: '+',
                  amount: travelAllowance,
                  currency: currency,
                ),
                const SizedBox(height: 10),
                _PayrollAdjustmentRow(
                  icon: Icons.restaurant_rounded,
                  label: 'Canteen',
                  sign: '-',
                  amount: canteenDeduction,
                  currency: currency,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _PayrollAdjustmentRow extends StatelessWidget {
  const _PayrollAdjustmentRow({
    required this.icon,
    required this.label,
    required this.sign,
    required this.amount,
    required this.currency,
  });

  final IconData icon;
  final String label;
  final String sign;
  final double amount;
  final dynamic currency;

  @override
  Widget build(BuildContext context) {
    final formattedAmount = MoneyFormatter.format(
      amount: amount,
      currency: currency,
    );

    return Row(
      children: [
        Icon(
          icon,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Text(
          '$sign$formattedAmount',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
