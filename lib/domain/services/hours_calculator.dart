import '../entities/app_settings.dart';
import '../entities/day_record.dart';
import 'company_rules_service.dart';

enum WorkSlotCategory { rest, regular, overtime, holiday }

final class HoursCalculationResult {
  const HoursCalculationResult({
    required this.regularHours,
    this.ukRegularHours = 0,
    this.nonUkRegularHours = 0,
    required this.overtimeHours,
    this.ukOvertimeHours = 0,
    this.nonUkOvertimeHours = 0,
    this.restHours = 0,
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
  final double ukRegularHours;
  final double nonUkRegularHours;
  final double overtimeHours;
  final double ukOvertimeHours;
  final double nonUkOvertimeHours;
  final double restHours;
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
    final isHoliday =
        CompanyRulesService.isCompanyHoliday(record.date, settings);
    final isObservedHoliday =
        CompanyRulesService.isObservedHoliday(record.date, settings);
    final forceHoliday = isObservedHoliday && !isWeekend;
    final forceOvertime =
        CompanyRulesService.isOvertimeDay(record.date, settings);

    var regularSlots = 0;
    var ukRegularSlots = 0;
    var nonUkRegularSlots = 0;
    var overtimeSlots = 0;
    var ukOvertimeSlots = 0;
    var nonUkOvertimeSlots = 0;
    var holidaySlots = 0;
    var restSlots = 0;
    final categories = <WorkSlotCategory>[];

    for (final slot in record.slots) {
      if (!slot.isWorked) {
        categories.add(WorkSlotCategory.rest);
        restSlots++;
        continue;
      }

      if (forceHoliday) {
        holidaySlots++;
        categories.add(WorkSlotCategory.holiday);
      } else if (forceOvertime) {
        overtimeSlots++;
        if (slot.isUkWaters) {
          ukOvertimeSlots++;
        } else {
          nonUkOvertimeSlots++;
        }
        categories.add(WorkSlotCategory.overtime);
      } else if (regularSlots < (settings.regularHours * 2).round()) {
        regularSlots++;
        if (slot.isUkWaters) {
          ukRegularSlots++;
        } else {
          nonUkRegularSlots++;
        }
        categories.add(WorkSlotCategory.regular);
      } else {
        overtimeSlots++;
        if (slot.isUkWaters) {
          ukOvertimeSlots++;
        } else {
          nonUkOvertimeSlots++;
        }
        categories.add(WorkSlotCategory.overtime);
      }
    }

    final regularHours = regularSlots * 0.5;
    final ukRegularHours = ukRegularSlots * 0.5;
    final nonUkRegularHours = nonUkRegularSlots * 0.5;
    final overtimeHours = overtimeSlots * 0.5;
    final ukOvertimeHours = ukOvertimeSlots * 0.5;
    final nonUkOvertimeHours = nonUkOvertimeSlots * 0.5;
    final restHours = restSlots * 0.5;
    final holidayHours = holidaySlots * 0.5;
    final totalHours = regularHours + overtimeHours + holidayHours;
    final regularPay = regularHours * settings.regularRate;
    final overtimePay = overtimeHours * settings.overtimeRate;
    final holidayPay = holidayHours * settings.holidayRate;

    return HoursCalculationResult(
      regularHours: regularHours,
      ukRegularHours: ukRegularHours,
      nonUkRegularHours: nonUkRegularHours,
      overtimeHours: overtimeHours,
      ukOvertimeHours: ukOvertimeHours,
      nonUkOvertimeHours: nonUkOvertimeHours,
      restHours: restHours,
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
