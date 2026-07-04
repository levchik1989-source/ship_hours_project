import '../entities/app_settings.dart';
import '../entities/day_record.dart';
import 'company_rules_service.dart';

enum WorkSlotCategory { rest, regular, overtime, holiday }

final class HoursCalculationResult {
  const HoursCalculationResult({
    required this.regularHours,
    required this.overtimeHours,
    required this.holidayHours,
    required this.totalHours,
    required this.regularPay,
    required this.overtimePay,
    required this.holidayPay,
    required this.totalPay,
    required this.slotCategories,
    required this.isWeekend,
    required this.isHoliday,
    required this.isObservedHoliday,
  });

  final double regularHours;
  final double overtimeHours;
  final double holidayHours;
  final double totalHours;
  final double regularPay;
  final double overtimePay;
  final double holidayPay;
  final double totalPay;
  final List<WorkSlotCategory> slotCategories;
  final bool isWeekend;
  final bool isHoliday;
  final bool isObservedHoliday;
}

final class HoursCalculator {
  const HoursCalculator._();

  static HoursCalculationResult calculate({
    required DayRecord record,
    required AppSettings settings,
  }) {
    final isWeekend = CompanyRulesService.isWeekend(record.date);
    final isHoliday = CompanyRulesService.isCompanyHoliday(record.date, settings);
    final isObservedHoliday = CompanyRulesService.isObservedHoliday(record.date, settings);
    final forceHoliday = isObservedHoliday && !isWeekend;
    final forceOvertime = CompanyRulesService.isOvertimeDay(record.date, settings);

    var regularSlots = 0;
    var overtimeSlots = 0;
    var holidaySlots = 0;
    final categories = <WorkSlotCategory>[];

    for (final slot in record.slots) {
      if (!slot.isWorked) {
        categories.add(WorkSlotCategory.rest);
        continue;
      }

      if (forceHoliday) {
        holidaySlots++;
        categories.add(WorkSlotCategory.holiday);
      } else if (forceOvertime) {
        overtimeSlots++;
        categories.add(WorkSlotCategory.overtime);
      } else if (regularSlots < (settings.regularHours * 2).round()) {
        regularSlots++;
        categories.add(WorkSlotCategory.regular);
      } else {
        overtimeSlots++;
        categories.add(WorkSlotCategory.overtime);
      }
    }

    final regularHours = regularSlots * 0.5;
    final overtimeHours = overtimeSlots * 0.5;
    final holidayHours = holidaySlots * 0.5;
    final totalHours = regularHours + overtimeHours + holidayHours;
    final regularPay = regularHours * settings.regularRate;
    final overtimePay = overtimeHours * settings.overtimeRate;
    final holidayPay = holidayHours * settings.overtimeRate;

    return HoursCalculationResult(
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      holidayHours: holidayHours,
      totalHours: totalHours,
      regularPay: regularPay,
      overtimePay: overtimePay,
      holidayPay: holidayPay,
      totalPay: regularPay + overtimePay + holidayPay,
      slotCategories: categories,
      isWeekend: isWeekend,
      isHoliday: isHoliday,
      isObservedHoliday: isObservedHoliday,
    );
  }
}
