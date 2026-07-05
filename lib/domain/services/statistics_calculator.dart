import '../entities/app_settings.dart';
import '../entities/day_record.dart';
import '../entities/month_statistics.dart';
import 'hours_calculator.dart';

final class StatisticsCalculator {
  const StatisticsCalculator._();

  static MonthStatistics calculate({
    required List<DayRecord> records,
    required AppSettings settings,
  }) {
    double regularHours = 0;
    double overtimeHours = 0;
    double holidayHours = 0;
    double totalHours = 0;
    double regularPay = 0;
    double overtimePay = 0;
    double holidayPay = 0;

    for (final record in records) {
      final result =
          HoursCalculator.calculate(record: record, settings: settings);
      regularHours += result.regularHours;
      overtimeHours += result.overtimeHours;
      holidayHours += result.holidayHours;
      totalHours += result.totalHours;
      regularPay += result.regularPay;
      holidayPay += result.holidayPay;
    }

    final daysInMonth = records.isEmpty
        ? 30
        : DateTime(records.first.date.year, records.first.date.month + 1, 0)
            .day;
    final regularMonthNorm = daysInMonth * 8.0;
    final workedMonthPart = regularMonthNorm > 0
        ? (regularHours / regularMonthNorm).clamp(0.0, 1.0)
        : 0.0;

    final fixedOvertimeHours = settings.fixedOvertimeEnabled
        ? settings.fixedOvertimeHours * workedMonthPart
        : 0.0;
    final paidOvertimeHours =
        (overtimeHours - fixedOvertimeHours).clamp(0.0, double.infinity);
    final paidOvertime = paidOvertimeHours;
    overtimePay = paidOvertime * settings.overtimeRate;
    final totalPay =
        settings.baseSalary + regularPay + overtimePay + holidayPay;

    return MonthStatistics(
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      fixedOvertimeHours: fixedOvertimeHours,
      paidOvertimeHours: paidOvertime,
      holidayHours: holidayHours,
      totalHours: totalHours,
      regularPay: regularPay,
      overtimePay: overtimePay,
      holidayPay: holidayPay,
      baseSalary: settings.baseSalary,
      totalPay: totalPay,
    );
  }
}
