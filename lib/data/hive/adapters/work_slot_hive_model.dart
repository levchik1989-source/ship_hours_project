import '../../../core/enums/work_slot_state.dart';
import '../../../domain/entities/work_slot.dart';

final class WorkSlotHiveModel {
  const WorkSlotHiveModel(
      {required this.index, required this.state, this.isUkWaters = true});

  factory WorkSlotHiveModel.fromEntity(WorkSlot slot) {
    return WorkSlotHiveModel(
        index: slot.index, state: slot.state.name, isUkWaters: slot.isUkWaters);
  }

  factory WorkSlotHiveModel.fromMap(Map<dynamic, dynamic> map) {
    return WorkSlotHiveModel(
        index: map['index'] as int,
        state: map['state'] as String,
        isUkWaters: map['isUkWaters'] as bool? ?? true);
  }

  final int index;
  final String state;
  final bool isUkWaters;

  WorkSlot toEntity() {
    return WorkSlot(
        index: index,
        state: WorkSlotState.fromName(state),
        isUkWaters: isUkWaters);
  }

  Map<String, dynamic> toMap() {
    return {'index': index, 'state': state, 'isUkWaters': isUkWaters};
  }
}
