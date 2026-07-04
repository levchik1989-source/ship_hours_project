import 'package:hive/hive.dart';

import '../../core/extensions/date_time_extensions.dart';
import '../../domain/entities/day_record.dart';
import '../../domain/repositories/work_hours_repository.dart';
import '../hive/adapters/day_record_hive_model.dart';

final class WorkHoursRepositoryImpl implements WorkHoursRepository {
  const WorkHoursRepositoryImpl({required this.dayRecordsBox});

  final Box<Map<dynamic, dynamic>> dayRecordsBox;

  @override
  Future<DayRecord> loadDay(DateTime date) async {
    final normalizedDate = date.dateOnly;
    final rawRecord = dayRecordsBox.get(normalizedDate.hiveKey);
    if (rawRecord == null) {
      final emptyRecord = DayRecordHiveModel.emptyEntity(normalizedDate);
      await saveDay(emptyRecord);
      return emptyRecord;
    }
    return DayRecordHiveModel.fromMap(rawRecord).toEntity();
  }

  @override
  Future<void> saveDay(DayRecord record) async {
    final normalizedRecord = record.copyWith(date: record.date.dateOnly);
    final model = DayRecordHiveModel.fromEntity(normalizedRecord);
    await dayRecordsBox.put(normalizedRecord.date.hiveKey, model.toMap());
  }

  @override
  Future<List<DayRecord>> loadMonth(DateTime month) async {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final records = <DayRecord>[];
    for (var day = 1; day <= lastDay.day; day++) {
      records.add(await loadDay(DateTime(month.year, month.month, day)));
    }
    return records;
  }
}
