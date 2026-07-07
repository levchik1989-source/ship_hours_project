import 'work_slot.dart';

final class DayRecord {
  const DayRecord(
      {required this.date, required this.slots, this.isUkWaters = true});

  final DateTime date;
  final List<WorkSlot> slots;
  final bool isUkWaters;

  int get workedSlots {
    return slots.where((slot) => slot.isWorked).length;
  }

  double get totalHours {
    return workedSlots * 0.5;
  }

  DayRecord copyWith(
      {DateTime? date, List<WorkSlot>? slots, bool? isUkWaters}) {
    return DayRecord(
      date: date ?? this.date,
      slots: slots ?? this.slots,
      isUkWaters: isUkWaters ?? this.isUkWaters,
    );
  }
}
