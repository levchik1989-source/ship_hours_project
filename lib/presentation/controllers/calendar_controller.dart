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
  double _travelAllowance = 0.0;
  double _canteenDeduction = 0.0;

  DateTime get selectedMonth => _selectedMonth;
  List<DayRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _isLoading;
  double get travelAllowance => _travelAllowance;
  double get canteenDeduction => _canteenDeduction;

  Future<void> loadCurrentMonth() async {
    await loadMonth(_selectedMonth);
  }

  Future<void> loadMonth(DateTime month) async {
    _isLoading = true;
    notifyListeners();
    _selectedMonth = DateTime(month.year, month.month);
    _records = await _repository.loadMonth(_selectedMonth);

    final adjustments =
        await _repository.loadMonthAdjustments(_selectedMonth);

    _travelAllowance =
        adjustments['travelAllowance'] ?? 0.0;
    _canteenDeduction =
        adjustments['canteenDeduction'] ?? 0.0;

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

  Future<void> saveMonthAdjustments({
    required double travelAllowance,
    required double canteenDeduction,
  }) async {
    final safeTravel = travelAllowance.isFinite
        ? travelAllowance
            .clamp(0.0, double.infinity)
            .toDouble()
        : 0.0;

    final safeCanteen = canteenDeduction.isFinite
        ? canteenDeduction
            .clamp(0.0, double.infinity)
            .toDouble()
        : 0.0;

    await _repository.saveMonthAdjustments(
      _selectedMonth,
      travelAllowance: safeTravel,
      canteenDeduction: safeCanteen,
    );

    _travelAllowance = safeTravel;
    _canteenDeduction = safeCanteen;

    notifyListeners();
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
