import '../entities/salary_profile.dart';

abstract interface class SalaryProfileRepository {
  Future<List<SalaryProfile>> loadProfiles();

  Future<void> saveProfiles(List<SalaryProfile> profiles);

  Future<String?> loadSelectedProfileId();

  Future<void> saveSelectedProfileId(String id);
}
