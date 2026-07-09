import '../entities/app_settings.dart';
import '../entities/day_record.dart';
import '../entities/salary_calculation.dart';
import '../entities/salary_profile.dart';
import 'hours_calculator.dart';

final class ProfileSalaryCalculator {
  const ProfileSalaryCalculator._();

  static SalaryCalculation calculate({
    required List<DayRecord> records,
    required AppSettings settings,
    required SalaryProfile profile,
    double travelAllowance = 0,
    double canteenDeduction = 0,
  }) {
    var ukHours = 0.0;
    var nonUkHours = 0.0;
    var ukOvertimeHours = 0.0;
    var nonUkOvertimeHours = 0.0;

    for (final record in records) {
      final result = HoursCalculator.calculate(
        record: record,
        settings: settings.copyWith(regularHours: profile.standardWorkDay),
      );

      ukHours += result.ukRegularHours + result.ukOvertimeHours;
      nonUkHours += result.nonUkRegularHours + result.nonUkOvertimeHours;
      ukOvertimeHours += result.ukOvertimeHours;
      nonUkOvertimeHours += result.nonUkOvertimeHours;
    }

    final totalHours = ukHours + nonUkHours;
    final payableDays = _payableDays(records);
    final guaranteedOtNorm = _guaranteedOtNorm(records, payableDays);

    final totalOvertimeHours = ukOvertimeHours + nonUkOvertimeHours;

    final usedGuaranteedOtHours = totalOvertimeHours <= 0
        ? 0.0
        : guaranteedOtNorm.clamp(0, totalOvertimeHours).toDouble();

    final guaranteedOtUkHours = totalOvertimeHours <= 0
        ? 0.0
        : usedGuaranteedOtHours * (ukOvertimeHours / totalOvertimeHours);

    final guaranteedOtNonUkHours = totalOvertimeHours <= 0
        ? 0.0
        : usedGuaranteedOtHours * (nonUkOvertimeHours / totalOvertimeHours);

    final extraOtUkHours = (ukOvertimeHours - guaranteedOtUkHours)
        .clamp(0, double.infinity)
        .toDouble();

    final extraOtNonUkHours = (nonUkOvertimeHours - guaranteedOtNonUkHours)
        .clamp(0, double.infinity)
        .toDouble();

    final monthPart = payableDays / 30;

    final basicUk =
        profile.basicUk * monthPart * _hoursPart(ukHours, totalHours);
    final basicNonUk =
        profile.basicNonUk * monthPart * _hoursPart(nonUkHours, totalHours);

    final leaveUk =
        profile.leaveUk * monthPart * _hoursPart(ukHours, totalHours);
    final leaveNonUk =
        profile.leaveNonUk * monthPart * _hoursPart(nonUkHours, totalHours);

    final guaranteedOtUk =
        guaranteedOtUkHours * _rate(profile.guaranteedOtUk);

    final guaranteedOtNonUk =
        guaranteedOtNonUkHours * _rate(profile.guaranteedOtNonUk);

    final extraOtUk = extraOtUkHours * profile.extraOtUkRate;
    final extraOtNonUk = extraOtNonUkHours * profile.extraOtNonUkRate;

    final lashingBonus = profile.lashingBonus;

    final total = basicUk +
        basicNonUk +
        leaveUk +
        leaveNonUk +
        guaranteedOtUk +
        guaranteedOtNonUk +
        extraOtUk +
        extraOtNonUk +
        lashingBonus +
        travelAllowance -
        canteenDeduction;

    return SalaryCalculation(
      payableDays: payableDays,
      totalHours: totalHours,
      ukHours: ukHours,
      nonUkHours: nonUkHours,
      ukOvertimeHours: ukOvertimeHours,
      nonUkOvertimeHours: nonUkOvertimeHours,
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
      lashingBonus: lashingBonus,
      travelAllowance: travelAllowance,
      canteenDeduction: canteenDeduction,
      total: total,
    );
  }

  static int _payableDays(List<DayRecord> records) {
    final payableRecords = records
        .where((record) => record.slots.any((slot) => slot.isWorked))
        .toList();

    if (payableRecords.isEmpty) return 0;

    final dates = payableRecords.map((e) => e.date).toList()..sort();
    final first = dates.first;
    final last = dates.last;

    final lastDayOfMonth = DateTime(first.year, first.month + 1, 0).day;
    final isFullMonth = first.day == 1 && last.day == lastDayOfMonth;

    if (isFullMonth) return 30;

    return payableRecords.length;
  }

  static double _guaranteedOtNorm(List<DayRecord> records, int payableDays) {
    if (records.isEmpty) return 0;
    return 103 * payableDays / 30;
  }

  static double _hoursPart(double hours, double totalHours) {
    if (totalHours == 0) return 0;
    return hours / totalHours;
  }

  static double _rate(double monthlyAmount) {
    return monthlyAmount / 103;
  }
}
