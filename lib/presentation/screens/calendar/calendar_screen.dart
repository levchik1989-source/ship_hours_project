import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_router.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../domain/services/statistics_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import '../../controllers/calendar_controller.dart';
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(localizations.calendar),
        centerTitle: true,
        actions: [
          IconButton.filledTonal(
            tooltip: localizations.statistics,
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRouter.statistics,
                arguments: controller.selectedMonth,
              );
            },
            icon: const Icon(Icons.bar_chart_rounded),
          ),
          IconButton.filledTonal(
            tooltip: localizations.settings,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settings);
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _CalendarSummary(
                    statistics: statistics, currency: settings.currency),
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
    required this.currency,
  });

  final dynamic statistics;
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
                    amount: statistics.totalPay,
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
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
