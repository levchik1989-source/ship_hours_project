import '../entities/day_record.dart';

abstract interface class WorkHoursRepository {
  Future<DayRecord> loadDay(DateTime date);
  Future<void> saveDay(DayRecord record);
  Future<List<DayRecord>> loadMonth(DateTime month);

  Future<Map<String, double>> loadMonthAdjustments(DateTime month);

  Future<void> saveMonthAdjustments(
    DateTime month, {
    required double travelAllowance,
    required double canteenDeduction,
  });
}
