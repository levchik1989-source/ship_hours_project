import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/hive_boxes.dart';

final class HiveDatabase {
  const HiveDatabase({required this.settingsBox, required this.dayRecordsBox});

  final Box<Map<dynamic, dynamic>> settingsBox;
  final Box<Map<dynamic, dynamic>> dayRecordsBox;
}

final class HiveInitializer {
  Future<HiveDatabase> initialize() async {
    await Hive.initFlutter();

    final settingsBox = await Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.settings);
    final dayRecordsBox = await Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.dayRecords);

    return HiveDatabase(settingsBox: settingsBox, dayRecordsBox: dayRecordsBox);
  }
}
