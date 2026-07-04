import '../data/hive/hive_initializer.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/work_hours_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/work_hours_repository.dart';

final class AppDependencies {
  const AppDependencies({
    required this.settingsRepository,
    required this.workHoursRepository,
  });

  final SettingsRepository settingsRepository;
  final WorkHoursRepository workHoursRepository;
}

final class AppBootstrap {
  Future<AppDependencies> initialize() async {
    final database = await HiveInitializer().initialize();

    return AppDependencies(
      settingsRepository: SettingsRepositoryImpl(
        settingsBox: database.settingsBox,
      ),
      workHoursRepository: WorkHoursRepositoryImpl(
        dayRecordsBox: database.dayRecordsBox,
      ),
    );
  }
}
