import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/hive_boxes.dart';
import '../../domain/entities/salary_profile.dart';
import '../../domain/repositories/salary_profile_repository.dart';

final class HiveSalaryProfileRepository implements SalaryProfileRepository {
  HiveSalaryProfileRepository({
    required Box<Map<dynamic, dynamic>> settingsBox,
    required Box<Map<dynamic, dynamic>> salaryProfilesBox,
  })  : _settingsBox = settingsBox,
        _salaryProfilesBox = salaryProfilesBox;

  final Box<Map<dynamic, dynamic>> _settingsBox;
  final Box<Map<dynamic, dynamic>> _salaryProfilesBox;

  @override
  Future<List<SalaryProfile>> loadProfiles() async {
    return const [];
  }

  @override
  Future<void> saveProfiles(List<SalaryProfile> profiles) async {}

  @override
  Future<String?> loadSelectedProfileId() async {
    final data = _settingsBox.get(HiveBoxes.selectedSalaryProfileKey);

    return data?['id'] as String?;
  }

  @override
  Future<void> saveSelectedProfileId(String? profileId) async {
    if (profileId == null) {
      await _settingsBox.delete(HiveBoxes.selectedSalaryProfileKey);
      return;
    }

    await _settingsBox.put(
      HiveBoxes.selectedSalaryProfileKey,
      {
        'id': profileId,
      },
    );
  }
}
