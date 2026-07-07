import 'package:flutter/material.dart';

import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/services/hours_calculator.dart';
import '../../../../l10n/app_localizations.dart';

final class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({
    required this.calculation,
    required this.settings,
    required this.totalPay,
    super.key,
  });

  final HoursCalculationResult calculation;
  final AppSettings settings;
  final double totalPay;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final note = calculation.isObservedHoliday && !calculation.isHoliday
        ? l.observedHoliday
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _BigMetricCard(
                  title: l.totalHours,
                  value: '${calculation.totalHours.toStringAsFixed(1)}h',
                  icon: Icons.schedule_rounded,
                  accent: const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _BigMetricCard(
                  title: l.totalPay,
                  value: MoneyFormatter.format(
                    amount: totalPay,
                    currency: settings.currency,
                  ),
                  icon: Icons.account_balance_wallet_outlined,
                  accent: const Color(0xFF00B7FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF071827),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SmallMetric(
                        title: 'UK Regular',
                        value: calculation.ukRegularHours,
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                    const _Divider(),
                    Expanded(
                      child: _SmallMetric(
                        title: 'Non-UK Regular',
                        value: calculation.nonUkRegularHours,
                        color: const Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SmallMetric(
                        title: 'UK OT',
                        value: calculation.ukOvertimeHours,
                        color: const Color(0xFFFF9800),
                      ),
                    ),
                    const _Divider(),
                    Expanded(
                      child: _SmallMetric(
                        title: 'Non-UK OT',
                        value: calculation.nonUkOvertimeHours,
                        color: const Color(0xFFFFC107),
                      ),
                    ),
                    const _Divider(),
                    Expanded(
                      child: _SmallMetric(
                        title: 'Rest',
                        value: calculation.restHours,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                if (calculation.holidayHours > 0) ...[
                  const SizedBox(height: 14),
                  _SmallMetric(
                    title: l.holidayHours,
                    value: calculation.holidayHours,
                    color: const Color(0xFFFF3B1F),
                  ),
                ],
              ],
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 8),
            Text(
              note,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFFFD54F),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _BigMetricCard extends StatelessWidget {
  const _BigMetricCard({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.25), const Color(0xFF071827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 34, color: accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
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

final class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${value.toStringAsFixed(1)}h',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

final class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 46,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
