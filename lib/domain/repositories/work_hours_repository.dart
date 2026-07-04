import '../entities/day_record.dart';

abstract interface class WorkHoursRepository {
  Future<DayRecord> loadDay(DateTime date);
  Future<void> saveDay(DayRecord record);
  Future<List<DayRecord>> loadMonth(DateTime month);
}
