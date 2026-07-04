import 'package:hive/hive.dart';

import '../../core/constants/hive_boxes.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../hive/adapters/app_settings_hive_model.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.settingsBox});

  final Box<Map<dynamic, dynamic>> settingsBox;

  @override
  Future<AppSettings> loadSettings() async {
    final rawSettings = settingsBox.get(HiveBoxes.appSettingsKey);
    if (rawSettings == null) {
      final defaultSettings = AppSettings.defaults();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }
    return AppSettingsHiveModel.fromMap(rawSettings).toEntity();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final model = AppSettingsHiveModel.fromEntity(settings);
    await settingsBox.put(HiveBoxes.appSettingsKey, model.toMap());
  }
}
