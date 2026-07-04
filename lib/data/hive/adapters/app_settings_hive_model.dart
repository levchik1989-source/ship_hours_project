import 'package:flutter/material.dart';

import '../../../core/enums/currency_type.dart';
import '../../../domain/entities/app_settings.dart';

final class AppSettingsHiveModel {
  const AppSettingsHiveModel({
    required this.regularHours,
    required this.regularRate,
    required this.overtimeRate,
    required this.currency,
    required this.themeMode,
    required this.languageCode,
    required this.weekendOvertimeEnabled,
    required this.moveWeekendHolidayToNextWorkday,
    required this.companyHolidays,
    required this.companyName,
    required this.vesselName,
    required this.rank,
    required this.contractStartDate,
    required this.contractEndDate,
  });

  factory AppSettingsHiveModel.fromEntity(AppSettings settings) {
    return AppSettingsHiveModel(
      regularHours: settings.regularHours,
      regularRate: settings.regularRate,
      overtimeRate: settings.overtimeRate,
      currency: settings.currency.name,
      themeMode: settings.themeMode.name,
      languageCode: settings.locale.languageCode,
      weekendOvertimeEnabled: settings.weekendOvertimeEnabled,
      moveWeekendHolidayToNextWorkday: settings.moveWeekendHolidayToNextWorkday,
      companyHolidays: settings.companyHolidays.map(_dateToKey).toList(),
      companyName: settings.companyName,
      vesselName: settings.vesselName,
      rank: settings.rank,
      contractStartDate: settings.contractStartDate == null ? null : _dateToKey(settings.contractStartDate!),
      contractEndDate: settings.contractEndDate == null ? null : _dateToKey(settings.contractEndDate!),
    );
  }

  factory AppSettingsHiveModel.fromMap(Map<dynamic, dynamic> map) {
    final defaults = AppSettings.defaults();
    return AppSettingsHiveModel(
      regularHours: ((map['regularHours'] ?? defaults.regularHours) as num).toDouble(),
      regularRate: ((map['regularRate'] ?? defaults.regularRate) as num).toDouble(),
      overtimeRate: ((map['overtimeRate'] ?? defaults.overtimeRate) as num).toDouble(),
      currency: (map['currency'] ?? defaults.currency.name) as String,
      themeMode: (map['themeMode'] ?? defaults.themeMode.name) as String,
      languageCode: (map['languageCode'] ?? defaults.locale.languageCode) as String,
      weekendOvertimeEnabled: (map['weekendOvertimeEnabled'] ?? true) as bool,
      moveWeekendHolidayToNextWorkday: (map['moveWeekendHolidayToNextWorkday'] ?? true) as bool,
      companyHolidays: ((map['companyHolidays'] as List?) ?? const []).map((value) => value.toString()).toList(),
      companyName: (map['companyName'] ?? '') as String,
      vesselName: (map['vesselName'] ?? '') as String,
      rank: (map['rank'] ?? '') as String,
      contractStartDate: map['contractStartDate'] as String?,
      contractEndDate: map['contractEndDate'] as String?,
    );
  }

  final double regularHours;
  final double regularRate;
  final double overtimeRate;
  final String currency;
  final String themeMode;
  final String languageCode;
  final bool weekendOvertimeEnabled;
  final bool moveWeekendHolidayToNextWorkday;
  final List<String> companyHolidays;
  final String companyName;
  final String vesselName;
  final String rank;
  final String? contractStartDate;
  final String? contractEndDate;

  AppSettings toEntity() {
    return AppSettings(
      regularHours: regularHours,
      regularRate: regularRate,
      overtimeRate: overtimeRate,
      currency: CurrencyType.fromName(currency),
      themeMode: _themeModeFromName(themeMode),
      locale: Locale(languageCode),
      weekendOvertimeEnabled: weekendOvertimeEnabled,
      moveWeekendHolidayToNextWorkday: moveWeekendHolidayToNextWorkday,
      companyHolidays: companyHolidays.map(_dateFromKey).whereType<DateTime>().toList(),
      companyName: companyName,
      vesselName: vesselName,
      rank: rank,
      contractStartDate: contractStartDate == null ? null : _dateFromKey(contractStartDate!),
      contractEndDate: contractEndDate == null ? null : _dateFromKey(contractEndDate!),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'regularHours': regularHours,
      'regularRate': regularRate,
      'overtimeRate': overtimeRate,
      'currency': currency,
      'themeMode': themeMode,
      'languageCode': languageCode,
      'weekendOvertimeEnabled': weekendOvertimeEnabled,
      'moveWeekendHolidayToNextWorkday': moveWeekendHolidayToNextWorkday,
      'companyHolidays': companyHolidays,
      'companyName': companyName,
      'vesselName': vesselName,
      'rank': rank,
      'contractStartDate': contractStartDate,
      'contractEndDate': contractEndDate,
    };
  }

  ThemeMode _themeModeFromName(String value) {
    return ThemeMode.values.firstWhere((mode) => mode.name == value, orElse: () => ThemeMode.system);
  }

  static String _dateToKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime? _dateFromKey(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }
}
