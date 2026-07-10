import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/month_statistics.dart';
import '../../../../domain/entities/salary_calculation.dart';

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
    final salary = salaryCalculation;

    if (salary == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No active salary profile selected'),
        ),
      );
    }

    final otHours = salary.ukOvertimeHours + salary.nonUkOvertimeHours;
    final totalEarnings = salary.total + salary.canteenDeduction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NetPayCard(
          value: MoneyFormatter.format(
            amount: salary.total,
            currency: settings.currency,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _MetricTile(
              icon: Icons.schedule_rounded,
              label: 'Total Hours',
              value: '${salary.totalHours.toStringAsFixed(1)}h',
              color: const Color(0xFF2196F3),
            ),
            _MetricTile(
              icon: Icons.anchor_rounded,
              label: 'UK Hours',
              value: '${salary.ukHours.toStringAsFixed(1)}h',
              color: const Color(0xFF2196F3),
            ),
            _MetricTile(
              icon: Icons.public_rounded,
              label: 'Non-UK Hours',
              value: '${salary.nonUkHours.toStringAsFixed(1)}h',
              color: const Color(0xFF38BDF8),
            ),
            _MetricTile(
              icon: Icons.work_history_rounded,
              label: 'OT Hours',
              value: '${otHours.toStringAsFixed(1)}h',
              color: const Color(0xFFFF9800),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _PayslipSection(
          number: '1',
          title: 'BASIC PAY',
          color: const Color(0xFF2196F3),
          total: salary.basicUk +
              salary.basicNonUk +
              salary.leaveUk +
              salary.leaveNonUk,
          settings: settings,
          rows: [
            _PayslipRow('Basic UK', salary.basicUk),
            _PayslipRow('Basic non-UK', salary.basicNonUk),
            _PayslipRow('Leave UK', salary.leaveUk),
            _PayslipRow('Leave non-UK', salary.leaveNonUk),
          ],
        ),
        _PayslipSection(
          number: '2',
          title: 'OVERTIME',
          color: const Color(0xFFFF9800),
          total: salary.guaranteedOtUk +
              salary.guaranteedOtNonUk +
              salary.extraOtUk +
              salary.extraOtNonUk,
          settings: settings,
          rows: [
            _PayslipRow(
              'Guaranteed OT UK (${salary.guaranteedOtUkHours.toStringAsFixed(1)}h)',
              salary.guaranteedOtUk,
            ),
            _PayslipRow(
              'Guaranteed OT non-UK (${salary.guaranteedOtNonUkHours.toStringAsFixed(1)}h)',
              salary.guaranteedOtNonUk,
            ),
            _PayslipRow(
              'Extra OT UK (${salary.extraOtUkHours.toStringAsFixed(1)}h)',
              salary.extraOtUk,
            ),
            _PayslipRow(
              'Extra OT non-UK (${salary.extraOtNonUkHours.toStringAsFixed(1)}h)',
              salary.extraOtNonUk,
            ),
          ],
        ),
        _PayslipSection(
          number: '3',
          title: 'ADDITIONAL',
          color: const Color(0xFFA855F7),
          total: salary.lashingBonus + salary.travelAllowance,
          settings: settings,
          rows: [
            _PayslipRow('Lashing bonus', salary.lashingBonus),
            _PayslipRow('Travel allowance', salary.travelAllowance),
          ],
        ),
        _PayslipSection(
          number: '4',
          title: 'DEDUCTIONS',
          color: const Color(0xFFFF3B30),
          total: salary.canteenDeduction,
          settings: settings,
          negative: true,
          rows: [
            _PayslipRow('Canteen', salary.canteenDeduction),
          ],
        ),
        const SizedBox(height: 8),
        _TotalsCard(
          totalEarnings: totalEarnings,
          totalDeductions: salary.canteenDeduction,
          netPay: salary.total,
          settings: settings,
        ),
        const SizedBox(height: 12),
        const _InfoCard(),
      ],
    );
  }
}

final class _NetPayCard extends StatelessWidget {
  const _NetPayCard({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF052E1A), Color(0xFF071827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF22C55E)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NET PAY',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF4ADE80),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.5)),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFF4ADE80),
              size: 34,
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
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF071827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

final class _PayslipSection extends StatelessWidget {
  const _PayslipSection({
    required this.number,
    required this.title,
    required this.color,
    required this.total,
    required this.rows,
    required this.settings,
    this.negative = false,
  });

  final String number;
  final String title;
  final Color color;
  final double total;
  final List<_PayslipRow> rows;
  final AppSettings settings;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.where((row) => row.amount != 0).toList();
    if (visibleRows.isEmpty) return const SizedBox.shrink();

    final totalText =
        MoneyFormatter.format(amount: total, currency: settings.currency);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF071827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                '${negative ? '-' : ''}$totalText',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: negative ? const Color(0xFFFF3B30) : color,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...visibleRows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Icon(Icons.circle, color: color, size: 8),
                  const SizedBox(width: 9),
                  Expanded(child: Text(row.label)),
                  Text(
                    '${negative ? '-' : ''}${MoneyFormatter.format(amount: row.amount, currency: settings.currency)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: negative ? const Color(0xFFFF6B6B) : null,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.totalEarnings,
    required this.totalDeductions,
    required this.netPay,
    required this.settings,
  });

  final double totalEarnings;
  final double totalDeductions;
  final double netPay;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF071827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _totalRow(context, 'TOTAL EARNINGS', totalEarnings),
          const SizedBox(height: 8),
          _totalRow(context, 'TOTAL DEDUCTIONS', -totalDeductions),
          const Divider(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'NET PAY',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Text(
                MoneyFormatter.format(
                    amount: netPay, currency: settings.currency),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF4ADE80),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalRow(BuildContext context, String label, double amount) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          MoneyFormatter.format(amount: amount, currency: settings.currency),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: amount < 0 ? const Color(0xFFFF6B6B) : null,
              ),
        ),
      ],
    );
  }
}

final class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF071827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'All amounts are calculated according to your active salary profile.',
            ),
          ),
        ],
      ),
    );
  }
}

final class _PayslipRow {
  const _PayslipRow(this.label, this.amount);

  final String label;
  final double amount;
}
