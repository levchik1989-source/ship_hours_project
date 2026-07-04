import 'package:flutter/material.dart';

import '../../core/extensions/date_time_extensions.dart';
import '../../domain/entities/day_record.dart';
import '../../domain/repositories/work_hours_repository.dart';

final class CalendarController extends ChangeNotifier {
  CalendarController({required WorkHoursRepository repository}) : _repository = repository;

  final WorkHoursRepository _repository;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<DayRecord> _records = [];
  bool _isLoading = false;

  DateTime get selectedMonth => _selectedMonth;
  List<DayRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _isLoading;

  Future<void> loadCurrentMonth() async {
    await loadMonth(_selectedMonth);
  }

  Future<void> loadMonth(DateTime month) async {
    _isLoading = true;
    notifyListeners();
    _selectedMonth = DateTime(month.year, month.month);
    _records = await _repository.loadMonth(_selectedMonth);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadMonth(_selectedMonth);
  }

  Future<void> previousMonth() async {
    await loadMonth(_selectedMonth.addMonths(-1));
  }

  Future<void> nextMonth() async {
    await loadMonth(_selectedMonth.addMonths(1));
  }

  DayRecord? recordFor(DateTime date) {
    for (final record in _records) {
      if (record.date.isSameDate(date)) {
        return record;
      }
    }
    return null;
  }
}
