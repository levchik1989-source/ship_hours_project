import 'package:flutter/material.dart';

import '../../domain/entities/salary_profile.dart';
import '../../domain/repositories/salary_profile_repository.dart';

final class SalaryProfileController extends ChangeNotifier {
  SalaryProfileController({required this.repository});

  final SalaryProfileRepository repository;

  List<SalaryProfile> _profiles = [];
  String? _activeId;

  List<SalaryProfile> get profiles => List.unmodifiable(_profiles);

  SalaryProfile? get activeProfile {
    if (_activeId == null) return null;
    try {
      return _profiles.firstWhere((p) => p.id == _activeId);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    _profiles = await repository.loadProfiles();
    _activeId = await repository.loadSelectedProfileId();
    notifyListeners();
  }

  Future<void> addProfile(SalaryProfile profile) async {
    _profiles.add(profile);

    await repository.saveProfiles(_profiles);

    if (_activeId == null) {
      _activeId = profile.id;
      await repository.saveSelectedProfileId(profile.id);
    }

    notifyListeners();
  }

  Future<void> updateProfile(SalaryProfile profile) async {
    final index = _profiles.indexWhere((e) => e.id == profile.id);

    if (index == -1) return;

    _profiles[index] = profile;

    await repository.saveProfiles(_profiles);

    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((e) => e.id == id);

    if (_activeId == id) {
      _activeId = _profiles.isEmpty ? null : _profiles.first.id;

      if (_activeId != null) {
        await repository.saveSelectedProfileId(_activeId!);
      }
    }

    await repository.saveProfiles(_profiles);

    notifyListeners();
  }

  Future<void> setActiveProfile(String id) async {
    _activeId = id;
    await repository.saveSelectedProfileId(id);
    notifyListeners();
  }
}
