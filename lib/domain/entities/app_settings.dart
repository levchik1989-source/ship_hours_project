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
  });

  factory AppSettings.defaults() {
    return const AppSettings(
      regularHours: AppConstants.defaultRegularHours,
      regularRate: AppConstants.defaultRegularRate,
      overtimeRate: AppConstants.defaultOvertimeRate,
      currency: CurrencyType.usd,
      themeMode: ThemeMode.system,
      locale: Locale('en'),
    );
  }

  final double regularHours;
  final double regularRate;
  final double overtimeRate;
  final CurrencyType currency;
  final ThemeMode themeMode;
  final Locale locale;

  AppSettings copyWith({
    double? regularHours,
    double? regularRate,
    double? overtimeRate,
    CurrencyType? currency,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettings(
      regularHours: regularHours ?? this.regularHours,
      regularRate: regularRate ?? this.regularRate,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
