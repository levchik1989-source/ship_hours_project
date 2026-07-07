import '../../domain/entities/salary_profile.dart';
import '../../domain/repositories/salary_profile_repository.dart';

final class InMemorySalaryProfileRepository implements SalaryProfileRepository {
  final List<SalaryProfile> _profiles = [];

  String? _activeProfileId;

  @override
  Future<List<SalaryProfile>> loadProfiles() async {
    return List.unmodifiable(_profiles);
  }

  @override
  Future<String?> loadSelectedProfileId() async {
    return _activeProfileId;
  }

  @override
  Future<void> saveProfiles(List<SalaryProfile> profiles) async {
    _profiles
      ..clear()
      ..addAll(profiles);

    if (_activeProfileId != null &&
        !_profiles.any((p) => p.id == _activeProfileId)) {
      _activeProfileId = null;
    }
  }

  @override
  Future<void> saveSelectedProfileId(String profileId) async {
    _activeProfileId = profileId;
  }
}
