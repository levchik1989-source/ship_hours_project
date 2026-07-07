import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/month_statistics.dart';
import '../../../../domain/entities/salary_calculation.dart';
import '../../../../l10n/app_localizations.dart';

final class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    required this.statistics,
    required this.settings,
    this.salaryCalculation,
    super.key,
  });

  final MonthStatistics statistics;
  final AppSettings settings;
  final SalaryCalculation? salaryCalculation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final salary = salaryCalculation;
    final totalPay = salary?.total ?? statistics.totalPay;
    final totalHours = salary?.totalHours ?? statistics.totalHours;
    final ukHours = salary?.ukHours ?? 0;
    final nonUkHours = salary?.nonUkHours ?? 0;
    final otHours = salary == null
        ? statistics.overtimeHours
        : salary.ukOvertimeHours + salary.nonUkOvertimeHours;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TotalPayCard(
          label: l.totalPay,
          value: MoneyFormatter.format(
            amount: totalPay,
            currency: settings.currency,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _MetricTile(
                icon: Icons.schedule,
                label: 'Total hours',
                value: '${totalHours.toStringAsFixed(1)}h'),
            _MetricTile(
                icon: Icons.anchor,
                label: 'UK hours',
                value: '${ukHours.toStringAsFixed(1)}h'),
            _MetricTile(
                icon: Icons.public,
                label: 'Non-UK hours',
                value: '${nonUkHours.toStringAsFixed(1)}h'),
            _MetricTile(
                icon: Icons.work_history,
                label: 'OT hours',
                value: '${otHours.toStringAsFixed(1)}h'),
          ],
        ),
        const SizedBox(height: 12),
        if (salary == null)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No active salary profile selected'),
            ),
          )
        else ...[
          _SectionCard(
            title: 'Basic pay',
            icon: Icons.payments_outlined,
            rows: [
              _PayRow('Basic UK', salary.basicUk),
              _PayRow('Basic non-UK', salary.basicNonUk),
              _PayRow('Leave UK', salary.leaveUk),
              _PayRow('Leave non-UK', salary.leaveNonUk),
            ],
            settings: settings,
          ),
          _SectionCard(
            title: 'Overtime',
            icon: Icons.timer_outlined,
            rows: [
              _PayRow('Guaranteed OT UK', salary.guaranteedOtUk),
              _PayRow('Guaranteed OT non-UK', salary.guaranteedOtNonUk),
              _PayRow('Extra OT UK', salary.extraOtUk),
              _PayRow('Extra OT non-UK', salary.extraOtNonUk),
            ],
            settings: settings,
          ),
          _SectionCard(
            title: 'Additional',
            icon: Icons.add_circle_outline,
            rows: [
              _PayRow('Lashing bonus', salary.lashingBonus),
              _PayRow('Travel allowance', salary.travelAllowance),
            ],
            settings: settings,
          ),
          _SectionCard(
            title: 'Deductions',
            icon: Icons.remove_circle_outline,
            negative: true,
            rows: [
              _PayRow('Canteen', salary.canteenDeduction),
            ],
            settings: settings,
          ),
        ],
      ],
    );
  }
}

final class _TotalPayCard extends StatelessWidget {
  const _TotalPayCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
        ),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

final class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.rows,
    required this.settings,
    this.negative = false,
  });

  final String title;
  final IconData icon;
  final List<_PayRow> rows;
  final AppSettings settings;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.where((row) => row.amount != 0).toList();
    if (visibleRows.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            ...visibleRows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(row.label)),
                    Text(
                      '${negative ? '-' : ''}${MoneyFormatter.format(amount: row.amount, currency: settings.currency)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PayRow {
  const _PayRow(this.label, this.amount);

  final String label;
  final double amount;
}
