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

  Future<void> _save(AppSettings settings) async {
    _settings = settings;
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> updateRegularHours(double value) async => _save(_settings.copyWith(regularHours: value));
  Future<void> updateRegularRate(double value) async => _save(_settings.copyWith(regularRate: value));
  Future<void> updateOvertimeRate(double value) async => _save(_settings.copyWith(overtimeRate: value));
  Future<void> updateCurrency(CurrencyType value) async => _save(_settings.copyWith(currency: value));
  Future<void> updateThemeMode(ThemeMode value) async => _save(_settings.copyWith(themeMode: value));
  Future<void> updateLocale(Locale value) async => _save(_settings.copyWith(locale: value));
  Future<void> updateWeekendOvertimeEnabled(bool value) async => _save(_settings.copyWith(weekendOvertimeEnabled: value));
  Future<void> updateMoveWeekendHolidayToNextWorkday(bool value) async => _save(_settings.copyWith(moveWeekendHolidayToNextWorkday: value));
  Future<void> updateCompanyName(String value) async => _save(_settings.copyWith(companyName: value));
  Future<void> updateVesselName(String value) async => _save(_settings.copyWith(vesselName: value));
  Future<void> updateRank(String value) async => _save(_settings.copyWith(rank: value));
  Future<void> updateContractStartDate(DateTime? value) async => _save(_settings.copyWith(contractStartDate: value, clearContractStartDate: value == null));
  Future<void> updateContractEndDate(DateTime? value) async => _save(_settings.copyWith(contractEndDate: value, clearContractEndDate: value == null));

  Future<void> addCompanyHoliday(DateTime value) async {
    final normalized = DateTime(value.year, value.month, value.day);
    final holidays = [..._settings.companyHolidays];
    final exists = holidays.any((date) => _sameDay(date, normalized));
    if (!exists) {
      holidays.add(normalized);
      holidays.sort((a, b) => a.compareTo(b));
      await _save(_settings.copyWith(companyHolidays: holidays));
    }
  }

  Future<void> removeCompanyHoliday(DateTime value) async {
    final holidays = _settings.companyHolidays.where((date) => !_sameDay(date, value)).toList();
    await _save(_settings.copyWith(companyHolidays: holidays));
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}
