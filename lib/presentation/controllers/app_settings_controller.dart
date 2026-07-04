import 'package:flutter/material.dart';

import '../../core/enums/currency_type.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

final class AppSettingsController extends ChangeNotifier {
  AppSettingsController({required this.repository});

  final SettingsRepository repository;
  AppSettings _settings = AppSettings.defaults();
  bool _isLoading = true;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _settings = await repository.loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateRegularHours(double value) async {
    _settings = _settings.copyWith(regularHours: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateRegularRate(double value) async {
    _settings = _settings.copyWith(regularRate: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateOvertimeRate(double value) async {
    _settings = _settings.copyWith(overtimeRate: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateCurrency(CurrencyType value) async {
    _settings = _settings.copyWith(currency: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateThemeMode(ThemeMode value) async {
    _settings = _settings.copyWith(themeMode: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateLocale(Locale value) async {
    _settings = _settings.copyWith(locale: value);
    notifyListeners();
    await repository.saveSettings(_settings);
  }
}
