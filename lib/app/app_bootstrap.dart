import '../data/hive/hive_initializer.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/work_hours_repository_impl.dart';
import '../data/salary_profiles/hive_salary_profile_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/work_hours_repository.dart';
import '../domain/repositories/salary_profile_repository.dart';

final class AppDependencies {
  const AppDependencies({
    required this.settingsRepository,
    required this.workHoursRepository,
    required this.salaryProfileRepository,
  });

  final SettingsRepository settingsRepository;
  final WorkHoursRepository workHoursRepository;
  final SalaryProfileRepository salaryProfileRepository;
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
      salaryProfileRepository: HiveSalaryProfileRepository(
        settingsBox: database.settingsBox,
        salaryProfilesBox: database.salaryProfilesBox,
      ),
    );
  }
}
