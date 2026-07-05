import 'package:flutter/material.dart';

import '../../../core/enums/currency_type.dart';
import '../../../domain/entities/app_settings.dart';

final class AppSettingsHiveModel {
  const AppSettingsHiveModel({
    required this.regularHours,
    required this.regularRate,
    required this.overtimeRate,
    required this.holidayRate,
    required this.baseSalary,
    required this.periodStartDay,
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
    required this.fixedOvertimeEnabled,
    required this.fixedOvertimeHours,
  });

  factory AppSettingsHiveModel.fromEntity(AppSettings settings) {
    return AppSettingsHiveModel(
      regularHours: settings.regularHours,
      regularRate: settings.regularRate,
      overtimeRate: settings.overtimeRate,
      holidayRate: settings.holidayRate,
      baseSalary: settings.baseSalary,
      periodStartDay: settings.periodStartDay,
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
      fixedOvertimeEnabled: settings.fixedOvertimeEnabled,
      fixedOvertimeHours: settings.fixedOvertimeHours,
    );
  }

  factory AppSettingsHiveModel.fromMap(Map<dynamic, dynamic> map) {
    final defaults = AppSettings.defaults();
    return AppSettingsHiveModel(
      regularHours: ((map['regularHours'] ?? defaults.regularHours) as num).toDouble(),
      regularRate: ((map['regularRate'] ?? defaults.regularRate) as num).toDouble(),
      overtimeRate: ((map['overtimeRate'] ?? defaults.overtimeRate) as num).toDouble(),
      holidayRate: ((map['holidayRate'] ?? defaults.holidayRate) as num).toDouble(),
      baseSalary: ((map['baseSalary'] ?? defaults.baseSalary) as num).toDouble(),
      periodStartDay: ((map['periodStartDay'] ?? defaults.periodStartDay) as num).toInt().clamp(1, 31).toInt(),
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
      fixedOvertimeEnabled: (map['fixedOvertimeEnabled'] ?? defaults.fixedOvertimeEnabled) as bool,
      fixedOvertimeHours: ((map['fixedOvertimeHours'] ?? defaults.fixedOvertimeHours) as num).toDouble(),
    );
  }

  final double regularHours;
  final double regularRate;
  final double overtimeRate;
  final double holidayRate;
  final double baseSalary;
  final int periodStartDay;
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
  final bool fixedOvertimeEnabled;
  final double fixedOvertimeHours;

  AppSettings toEntity() {
    return AppSettings(
      regularHours: regularHours,
      regularRate: regularRate,
      overtimeRate: overtimeRate,
      holidayRate: holidayRate,
      baseSalary: baseSalary,
      periodStartDay: periodStartDay,
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
      fixedOvertimeEnabled: fixedOvertimeEnabled,
      fixedOvertimeHours: fixedOvertimeHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'regularHours': regularHours,
      'regularRate': regularRate,
      'overtimeRate': overtimeRate,
      'holidayRate': holidayRate,
      'baseSalary': baseSalary,
      'periodStartDay': periodStartDay,
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
      'fixedOvertimeEnabled': fixedOvertimeEnabled,
      'fixedOvertimeHours': fixedOvertimeHours,
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
