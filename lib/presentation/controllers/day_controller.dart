import 'package:flutter/material.dart';

import '../../core/enums/work_slot_state.dart';
import '../../domain/entities/day_record.dart';
import '../../domain/entities/work_slot.dart';
import '../../domain/repositories/work_hours_repository.dart';

final class DayController extends ChangeNotifier {
  DayController({required WorkHoursRepository repository, required DateTime selectedDate})
      : _repository = repository,
        _selectedDate = selectedDate;

  final WorkHoursRepository _repository;
  final DateTime _selectedDate;
  DayRecord? _record;
  bool _isLoading = false;

  DayRecord? get record => _record;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _record = await _repository.loadDay(_selectedDate);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSlot(int index) async {
    final currentRecord = _record;
    if (currentRecord == null || index < 0 || index >= currentRecord.slots.length) {
      return;
    }
    final slots = List<WorkSlot>.from(currentRecord.slots);
    final currentSlot = slots[index];
    slots[index] = currentSlot.copyWith(state: currentSlot.state.toggled());
    _record = currentRecord.copyWith(slots: slots);
    notifyListeners();
    await _repository.saveDay(_record!);
  }

  Future<void> clearDay() async {
    final currentRecord = _record;
    if (currentRecord == null) {
      return;
    }
    final slots = List.generate(
      currentRecord.slots.length,
      (index) => WorkSlot(index: index, state: WorkSlotState.rest),
    );
    _record = currentRecord.copyWith(slots: slots);
    notifyListeners();
    await _repository.saveDay(_record!);
  }
}
