final class CldnWageInput {
  const CldnWageInput({
    required this.startDate,
    required this.endDate,
    required this.ukTotalHours,
    required this.nonUkTotalHours,
    required this.ukOvertimeHours,
    required this.nonUkOvertimeHours,
    required this.basicUkMonthly,
    required this.basicNonUkMonthly,
    required this.leaveUkMonthly,
    required this.leaveNonUkMonthly,
    required this.guaranteedOtUkMonthly,
    required this.guaranteedOtNonUkMonthly,
    required this.extraOtUkRate,
    required this.extraOtNonUkRate,
    required this.canteenDeduction,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double ukTotalHours;
  final double nonUkTotalHours;
  final double ukOvertimeHours;
  final double nonUkOvertimeHours;
  final double basicUkMonthly;
  final double basicNonUkMonthly;
  final double leaveUkMonthly;
  final double leaveNonUkMonthly;
  final double guaranteedOtUkMonthly;
  final double guaranteedOtNonUkMonthly;
  final double extraOtUkRate;
  final double extraOtNonUkRate;
  final double canteenDeduction;
}

final class CldnWageResult {
  const CldnWageResult({
    required this.payableDays,
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
    required this.canteenDeduction,
    required this.total,
  });

  final int payableDays;
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
  final double canteenDeduction;
  final double total;
}

final class CldnWageCalculator {
  const CldnWageCalculator._();

  static CldnWageResult calculate(CldnWageInput input) {
    final payableDays = _payableDays(input.startDate, input.endDate);
    final daysRatio = payableDays / 30.0;

    final totalHours = input.ukTotalHours + input.nonUkTotalHours;
    final ukHoursRatio =
        totalHours == 0 ? 0.0 : input.ukTotalHours / totalHours;
    final nonUkHoursRatio =
        totalHours == 0 ? 0.0 : input.nonUkTotalHours / totalHours;

    final guaranteedOtNorm = 103.0 * daysRatio;
    final totalOtHours = input.ukOvertimeHours + input.nonUkOvertimeHours;
    final guaranteedRatio = totalOtHours == 0
        ? 0.0
        : (guaranteedOtNorm / totalOtHours).clamp(0.0, 1.0);

    final guaranteedOtUkHours = input.ukOvertimeHours * guaranteedRatio;
    final guaranteedOtNonUkHours = input.nonUkOvertimeHours * guaranteedRatio;
    final extraOtUkHours = input.ukOvertimeHours - guaranteedOtUkHours;
    final extraOtNonUkHours = input.nonUkOvertimeHours - guaranteedOtNonUkHours;

    final basicUk = input.basicUkMonthly * daysRatio * ukHoursRatio;
    final basicNonUk = input.basicNonUkMonthly * daysRatio * nonUkHoursRatio;
    final leaveUk = input.leaveUkMonthly * daysRatio * ukHoursRatio;
    final leaveNonUk = input.leaveNonUkMonthly * daysRatio * nonUkHoursRatio;

    final guaranteedOtUk = input.guaranteedOtUkMonthly *
        daysRatio *
        (guaranteedOtNorm == 0 ? 0.0 : guaranteedOtUkHours / guaranteedOtNorm);
    final guaranteedOtNonUk = input.guaranteedOtNonUkMonthly *
        daysRatio *
        (guaranteedOtNorm == 0
            ? 0.0
            : guaranteedOtNonUkHours / guaranteedOtNorm);

    final extraOtUk = extraOtUkHours * input.extraOtUkRate;
    final extraOtNonUk = extraOtNonUkHours * input.extraOtNonUkRate;

    final total = basicUk +
        basicNonUk +
        leaveUk +
        leaveNonUk +
        guaranteedOtUk +
        guaranteedOtNonUk +
        extraOtUk +
        extraOtNonUk -
        input.canteenDeduction;

    return CldnWageResult(
      payableDays: payableDays,
      guaranteedOtNorm: guaranteedOtNorm,
      guaranteedOtUkHours: guaranteedOtUkHours,
      guaranteedOtNonUkHours: guaranteedOtNonUkHours,
      extraOtUkHours: extraOtUkHours,
      extraOtNonUkHours: extraOtNonUkHours,
      basicUk: basicUk,
      basicNonUk: basicNonUk,
      leaveUk: leaveUk,
      leaveNonUk: leaveNonUk,
      guaranteedOtUk: guaranteedOtUk,
      guaranteedOtNonUk: guaranteedOtNonUk,
      extraOtUk: extraOtUk,
      extraOtNonUk: extraOtNonUk,
      canteenDeduction: input.canteenDeduction,
      total: total,
    );
  }

  static int _payableDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    final lastDay = DateTime(e.year, e.month + 1, 0).day;
    final isFullMonth = s.day == 1 && e.day == lastDay;
    if (isFullMonth) return 30;
    return e.difference(s).inDays + 1;
  }
}
