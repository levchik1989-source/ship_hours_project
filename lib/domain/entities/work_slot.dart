import '../../core/enums/work_slot_state.dart';

final class WorkSlot {
  const WorkSlot(
      {required this.index, required this.state, this.isUkWaters = true});

  final int index;
  final WorkSlotState state;
  final bool isUkWaters;

  bool get isWorked => state.isWork;

  WorkSlot copyWith({int? index, WorkSlotState? state, bool? isUkWaters}) {
    return WorkSlot(
      index: index ?? this.index,
      state: state ?? this.state,
      isUkWaters: isUkWaters ?? this.isUkWaters,
    );
  }
}
