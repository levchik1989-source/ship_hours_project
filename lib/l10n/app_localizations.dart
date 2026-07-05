import 'package:flutter/material.dart';

import 'app_localizations_bg.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

abstract class AppLocalizations {
  const AppLocalizations();

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('uk'),
    Locale('ru'),
    Locale('pl'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
    Locale('pt'),
    Locale('nl'),
    Locale('ro'),
    Locale('bg'),
    Locale('tr'),
    Locale('fil'),
    Locale('zh'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appName;
  String get calendar;
  String get day;
  String get statistics;
  String get settings;
  String get regularHours;
  String get overtimeHours;
  String get totalHours;
  String get regularRate;
  String get overtimeRate;
  String get regularPay;
  String get overtimePay;
  String get totalPay;
  String get currency;
  String get theme;
  String get systemTheme;
  String get lightTheme;
  String get darkTheme;
  String get language;
  String get clearDay;
  String get holidayHours => 'Holiday Hours';
  String get holidayPay => 'Holiday Pay';
  String get companyRules => 'Company rules';
  String get weekendOvertime => 'All weekend hours are overtime';
  String get moveWeekendHoliday => 'Move weekend holidays to next working day';
  String get companyHolidays => 'Company holidays';
  String get addHoliday => 'Add holiday';
  String get noHolidays => 'No company holidays yet';
  String get contract => 'Contract';
  String get company => 'Company';
  String get vessel => 'Vessel';
  String get rank => 'Rank';
  String get contractStart => 'Contract start';
  String get contractEnd => 'Contract end';
  String get notSet => 'Not set';
  String get observedHoliday => 'Observed holiday';
  String get regularShort => 'Regular';
  String get overtimeShort => 'OT';
  String get holidayShort => 'Holiday';
  String get nightShort => 'Night';
  String get emptyShort => 'Empty';
  String get fixedOvertime => 'Fixed overtime';
  String get fixedOvertimeEnabled => 'Use fixed monthly overtime';
  String get fixedOvertimeHours => 'Fixed overtime hours per month';
  String get fixedOvertimeHint => 'For companies with guaranteed monthly OT, for example 103h or 107h.';
}

final class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'uk':
        return const AppLocalizationsUk();
      case 'ru':
        return const AppLocalizationsRu();
      case 'pl':
        return const AppLocalizationsPl();
      case 'de':
        return const AppLocalizationsDe();
      case 'fr':
        return const AppLocalizationsFr();
      case 'es':
        return const AppLocalizationsEs();
      case 'it':
        return const AppLocalizationsIt();
      case 'pt':
        return const AppLocalizationsPt();
      case 'nl':
        return const AppLocalizationsNl();
      case 'ro':
        return const AppLocalizationsRo();
      case 'bg':
        return const AppLocalizationsBg();
      case 'tr':
        return const AppLocalizationsTr();
      case 'fil':
        return const AppLocalizationsFil();
      case 'zh':
        return const AppLocalizationsZh();
      case 'en':
      default:
        return const AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
