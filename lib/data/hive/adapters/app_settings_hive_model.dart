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
  });

  factory AppSettingsHiveModel.fromEntity(AppSettings settings) {
    return AppSettingsHiveModel(
      regularHours: settings.regularHours,
      regularRate: settings.regularRate,
      overtimeRate: settings.overtimeRate,
      currency: settings.currency.name,
      themeMode: settings.themeMode.name,
      languageCode: settings.locale.languageCode,
    );
  }

  factory AppSettingsHiveModel.fromMap(Map<dynamic, dynamic> map) {
    return AppSettingsHiveModel(
      regularHours: (map['regularHours'] as num).toDouble(),
      regularRate: (map['regularRate'] as num).toDouble(),
      overtimeRate: (map['overtimeRate'] as num).toDouble(),
      currency: map['currency'] as String,
      themeMode: map['themeMode'] as String,
      languageCode: map['languageCode'] as String,
    );
  }

  final double regularHours;
  final double regularRate;
  final double overtimeRate;
  final String currency;
  final String themeMode;
  final String languageCode;

  AppSettings toEntity() {
    return AppSettings(
      regularHours: regularHours,
      regularRate: regularRate,
      overtimeRate: overtimeRate,
      currency: CurrencyType.fromName(currency),
      themeMode: _themeModeFromName(themeMode),
      locale: Locale(languageCode),
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
    };
  }

  ThemeMode _themeModeFromName(String value) {
    return ThemeMode.values.firstWhere((mode) => mode.name == value, orElse: () => ThemeMode.system);
  }
}
