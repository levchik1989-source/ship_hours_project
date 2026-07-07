import '../../../core/constants/app_constants.dart';
import '../../../core/enums/work_slot_state.dart';
import '../../../domain/entities/day_record.dart';
import '../../../domain/entities/work_slot.dart';
import 'work_slot_hive_model.dart';

final class DayRecordHiveModel {
  const DayRecordHiveModel(
      {required this.date, required this.slots, this.isUkWaters = true});

  factory DayRecordHiveModel.empty(DateTime date) {
    return DayRecordHiveModel(
      date: date.toIso8601String(),
      isUkWaters: true,
      slots: List.generate(
        AppConstants.totalSlotsPerDay,
        (index) =>
            WorkSlotHiveModel(index: index, state: WorkSlotState.rest.name),
      ),
    );
  }

  factory DayRecordHiveModel.fromEntity(DayRecord record) {
    return DayRecordHiveModel(
      date: record.date.toIso8601String(),
      isUkWaters: record.isUkWaters,
      slots: record.slots.map(WorkSlotHiveModel.fromEntity).toList(),
    );
  }

  factory DayRecordHiveModel.fromMap(Map<dynamic, dynamic> map) {
    final rawSlots = map['slots'] as List<dynamic>;
    return DayRecordHiveModel(
      date: map['date'] as String,
      isUkWaters: map['isUkWaters'] as bool? ?? true,
      slots: rawSlots
          .map((slot) =>
              WorkSlotHiveModel.fromMap(slot as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  final String date;
  final List<WorkSlotHiveModel> slots;
  final bool isUkWaters;

  DayRecord toEntity() {
    return DayRecord(
      date: DateTime.parse(date),
      slots: slots.map((slot) => slot.toEntity()).toList(),
      isUkWaters: isUkWaters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'isUkWaters': isUkWaters,
      'slots': slots.map((slot) => slot.toMap()).toList(),
    };
  }

  static DayRecord emptyEntity(DateTime date) {
    return DayRecord(
      date: date,
      isUkWaters: true,
      slots: List.generate(
        AppConstants.totalSlotsPerDay,
        (index) => WorkSlot(index: index, state: WorkSlotState.rest),
      ),
    );
  }
}
