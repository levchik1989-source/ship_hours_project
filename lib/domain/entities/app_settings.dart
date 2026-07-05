import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/enums/currency_type.dart';

final class AppSettings {
  const AppSettings({
    required this.regularHours,
    required this.regularRate,
    required this.overtimeRate,
    required this.currency,
    required this.themeMode,
    required this.locale,
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

  factory AppSettings.defaults() {
    return const AppSettings(
      regularHours: AppConstants.defaultRegularHours,
      regularRate: AppConstants.defaultRegularRate,
      overtimeRate: AppConstants.defaultOvertimeRate,
      currency: CurrencyType.usd,
      themeMode: ThemeMode.system,
      locale: Locale('en'),
      weekendOvertimeEnabled: true,
      moveWeekendHolidayToNextWorkday: true,
      companyHolidays: [],
      companyName: '',
      vesselName: '',
      rank: '',
      contractStartDate: null,
      contractEndDate: null,
      fixedOvertimeEnabled: false,
      fixedOvertimeHours: 103,
    );
  }

  final double regularHours;
  final double regularRate;
  final double overtimeRate;
  final CurrencyType currency;
  final ThemeMode themeMode;
  final Locale locale;
  final bool weekendOvertimeEnabled;
  final bool moveWeekendHolidayToNextWorkday;
  final List<DateTime> companyHolidays;
  final String companyName;
  final String vesselName;
  final String rank;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final bool fixedOvertimeEnabled;
  final double fixedOvertimeHours;

  AppSettings copyWith({
    double? regularHours,
    double? regularRate,
    double? overtimeRate,
    CurrencyType? currency,
    ThemeMode? themeMode,
    Locale? locale,
    bool? weekendOvertimeEnabled,
    bool? moveWeekendHolidayToNextWorkday,
    List<DateTime>? companyHolidays,
    String? companyName,
    String? vesselName,
    String? rank,
    DateTime? contractStartDate,
    bool clearContractStartDate = false,
    DateTime? contractEndDate,
    bool clearContractEndDate = false,
    bool? fixedOvertimeEnabled,
    double? fixedOvertimeHours,
  }) {
    return AppSettings(
      regularHours: regularHours ?? this.regularHours,
      regularRate: regularRate ?? this.regularRate,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      weekendOvertimeEnabled: weekendOvertimeEnabled ?? this.weekendOvertimeEnabled,
      moveWeekendHolidayToNextWorkday: moveWeekendHolidayToNextWorkday ?? this.moveWeekendHolidayToNextWorkday,
      companyHolidays: companyHolidays ?? this.companyHolidays,
      companyName: companyName ?? this.companyName,
      vesselName: vesselName ?? this.vesselName,
      rank: rank ?? this.rank,
      contractStartDate: clearContractStartDate ? null : contractStartDate ?? this.contractStartDate,
      contractEndDate: clearContractEndDate ? null : contractEndDate ?? this.contractEndDate,
      fixedOvertimeEnabled: fixedOvertimeEnabled ?? this.fixedOvertimeEnabled,
      fixedOvertimeHours: fixedOvertimeHours ?? this.fixedOvertimeHours,
    );
  }
}
