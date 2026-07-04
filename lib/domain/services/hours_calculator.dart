import '../entities/app_settings.dart';
import '../entities/day_record.dart';

final class HoursCalculationResult {
  const HoursCalculationResult({
    required this.regularHours,
    required this.overtimeHours,
    required this.totalHours,
    required this.regularPay,
    required this.overtimePay,
    required this.totalPay,
  });

  final double regularHours;
  final double overtimeHours;
  final double totalHours;
  final double regularPay;
  final double overtimePay;
  final double totalPay;
}

final class HoursCalculator {
  const HoursCalculator._();

  static HoursCalculationResult calculate({
    required DayRecord record,
    required AppSettings settings,
  }) {
    final totalHours = record.totalHours;
    final regularHours = totalHours <= settings.regularHours ? totalHours : settings.regularHours;
    final overtimeHours = totalHours > settings.regularHours ? totalHours - settings.regularHours : 0.0;
    final regularPay = regularHours * settings.regularRate;
    final overtimePay = overtimeHours * settings.overtimeRate;

    return HoursCalculationResult(
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      totalHours: totalHours,
      regularPay: regularPay,
      overtimePay: overtimePay,
      totalPay: regularPay + overtimePay,
    );
  }
}
