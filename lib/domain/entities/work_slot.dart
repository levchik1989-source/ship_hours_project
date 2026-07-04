import '../../core/enums/work_slot_state.dart';

final class WorkSlot {
  const WorkSlot({required this.index, required this.state});

  final int index;
  final WorkSlotState state;

  bool get isWorked => state.isWork;

  WorkSlot copyWith({int? index, WorkSlotState? state}) {
    return WorkSlot(index: index ?? this.index, state: state ?? this.state);
  }
}
