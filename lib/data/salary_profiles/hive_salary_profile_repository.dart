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
    return _salaryProfilesBox.values.map(_fromMap).toList();
  }

  @override
  Future<void> saveProfiles(List<SalaryProfile> profiles) async {
    await _salaryProfilesBox.clear();

    for (final profile in profiles) {
      await _salaryProfilesBox.put(profile.id, _toMap(profile));
    }
  }

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
      {'id': profileId},
    );
  }

  Map<dynamic, dynamic> _toMap(SalaryProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'basicUk': profile.basicUk,
      'basicNonUk': profile.basicNonUk,
      'leaveUk': profile.leaveUk,
      'leaveNonUk': profile.leaveNonUk,
      'guaranteedOtUk': profile.guaranteedOtUk,
      'guaranteedOtNonUk': profile.guaranteedOtNonUk,
      'extraOtUkRate': profile.extraOtUkRate,
      'extraOtNonUkRate': profile.extraOtNonUkRate,
      'standardWorkDay': profile.standardWorkDay,
      'lashingBonus': profile.lashingBonus,
    };
  }

  SalaryProfile _fromMap(Map<dynamic, dynamic> map) {
    return SalaryProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      basicUk: (map['basicUk'] as num).toDouble(),
      basicNonUk: (map['basicNonUk'] as num).toDouble(),
      leaveUk: (map['leaveUk'] as num).toDouble(),
      leaveNonUk: (map['leaveNonUk'] as num).toDouble(),
      guaranteedOtUk: (map['guaranteedOtUk'] as num).toDouble(),
      guaranteedOtNonUk: (map['guaranteedOtNonUk'] as num).toDouble(),
      extraOtUkRate: (map['extraOtUkRate'] as num).toDouble(),
      extraOtNonUkRate: (map['extraOtNonUkRate'] as num).toDouble(),
      standardWorkDay: (map['standardWorkDay'] as num).toDouble(),
      lashingBonus: (map['lashingBonus'] as num).toDouble(),
    );
  }
}
