import 'package:ship_hours/domain/services/cldn/cldn_wage_calculator.dart';

void main() {
  final result = CldnWageCalculator.calculate(
    CldnWageInput(
      startDate: DateTime(2026, 7, 1),
      endDate: DateTime(2026, 7, 4),
      ukTotalHours: 20,
      nonUkTotalHours: 20,
      ukOvertimeHours: 12,
      nonUkOvertimeHours: 4,
      basicUkMonthly: 2576.37,
      basicNonUkMonthly: 685.88,
      leaveUkMonthly: 214.70,
      leaveNonUkMonthly: 57.16,
      guaranteedOtUkMonthly: 1917.38,
      guaranteedOtNonUkMonthly: 510.44,
      extraOtUkRate: 18.62,
      extraOtNonUkRate: 4.96,
      canteenDeduction: 0,
    ),
  );

  String f(double v) => v.toStringAsFixed(2);

  print('Payable days: ${result.payableDays}');
  print('Guaranteed OT norm: ${f(result.guaranteedOtNorm)}h');
  print('Guaranteed OT UK hours: ${f(result.guaranteedOtUkHours)}h');
  print('Guaranteed OT non-UK hours: ${f(result.guaranteedOtNonUkHours)}h');
  print('Extra OT UK hours: ${f(result.extraOtUkHours)}h');
  print('Extra OT non-UK hours: ${f(result.extraOtNonUkHours)}h');
  print('');
  print('Basic UK: €${f(result.basicUk)}');
  print('Basic non-UK: €${f(result.basicNonUk)}');
  print('Leave UK: €${f(result.leaveUk)}');
  print('Leave non-UK: €${f(result.leaveNonUk)}');
  print('Guaranteed OT UK: €${f(result.guaranteedOtUk)}');
  print('Guaranteed OT non-UK: €${f(result.guaranteedOtNonUk)}');
  print('Extra OT UK: €${f(result.extraOtUk)}');
  print('Extra OT non-UK: €${f(result.extraOtNonUk)}');
  print('Canteen: -€${f(result.canteenDeduction)}');
  print('TOTAL: €${f(result.total)}');
}
