import 'package:flutter_test/flutter_test.dart';
import 'package:ship_hours/core/enums/work_slot_state.dart';
import 'package:ship_hours/domain/entities/app_settings.dart';
import 'package:ship_hours/domain/entities/day_record.dart';
import 'package:ship_hours/domain/entities/work_slot.dart';
import 'package:ship_hours/domain/services/hours_calculator.dart';

void main() {
  test('calculates regular and overtime hours', () {
    final record = DayRecord(
      date: DateTime(2026, 1, 1),
      slots: List.generate(
        20,
        (index) => WorkSlot(index: index, state: WorkSlotState.work),
      ),
    );

    final result = HoursCalculator.calculate(
      record: record,
      settings: AppSettings.defaults().copyWith(
        regularHours: 8,
        regularRate: 10,
        overtimeRate: 20,
      ),
    );

    expect(result.totalHours, 10);
    expect(result.regularHours, 8);
    expect(result.overtimeHours, 2);
    expect(result.totalPay, 120);
  });
}
