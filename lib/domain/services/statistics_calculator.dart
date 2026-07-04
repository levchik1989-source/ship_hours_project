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
      final result = HoursCalculator.calculate(record: record, settings: settings);
      regularHours += result.regularHours;
      overtimeHours += result.overtimeHours;
      holidayHours += result.holidayHours;
      totalHours += result.totalHours;
      regularPay += result.regularPay;
      overtimePay += result.overtimePay;
      holidayPay += result.holidayPay;
    }

    return MonthStatistics(
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      holidayHours: holidayHours,
      totalHours: totalHours,
      regularPay: regularPay,
      overtimePay: overtimePay,
      holidayPay: holidayPay,
      totalPay: regularPay + overtimePay + holidayPay,
    );
  }
}
