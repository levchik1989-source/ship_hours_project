final class SalaryCalculation {
  const SalaryCalculation({
    required this.payableDays,
    required this.totalHours,
    required this.ukHours,
    required this.nonUkHours,
    required this.ukOvertimeHours,
    required this.nonUkOvertimeHours,
    required this.guaranteedOtNorm,
    required this.guaranteedOtUkHours,
    required this.guaranteedOtNonUkHours,
    required this.extraOtUkHours,
    required this.extraOtNonUkHours,
    required this.basicUk,
    required this.basicNonUk,
    required this.leaveUk,
    required this.leaveNonUk,
    required this.guaranteedOtUk,
    required this.guaranteedOtNonUk,
    required this.extraOtUk,
    required this.extraOtNonUk,
    required this.lashingBonus,
    required this.travelAllowance,
    required this.canteenDeduction,
    required this.total,
  });

  final int payableDays;
  final double totalHours;
  final double ukHours;
  final double nonUkHours;
  final double ukOvertimeHours;
  final double nonUkOvertimeHours;
  final double guaranteedOtNorm;
  final double guaranteedOtUkHours;
  final double guaranteedOtNonUkHours;
  final double extraOtUkHours;
  final double extraOtNonUkHours;
  final double basicUk;
  final double basicNonUk;
  final double leaveUk;
  final double leaveNonUk;
  final double guaranteedOtUk;
  final double guaranteedOtNonUk;
  final double extraOtUk;
  final double extraOtNonUk;
  final double lashingBonus;
  final double travelAllowance;
  final double canteenDeduction;
  final double total;
}
