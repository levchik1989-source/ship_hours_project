import 'package:flutter/material.dart';

final class SupportedLanguage {
  const SupportedLanguage({
    required this.locale,
    required this.nativeName,
    required this.englishName,
  });

  final Locale locale;
  final String nativeName;
  final String englishName;
}

final class SupportedLanguages {
  const SupportedLanguages._();

  static const List<SupportedLanguage> values = [
    SupportedLanguage(locale: Locale('en'), nativeName: 'English', englishName: 'English'),
    SupportedLanguage(locale: Locale('uk'), nativeName: 'Українська', englishName: 'Ukrainian'),
    SupportedLanguage(locale: Locale('pl'), nativeName: 'Polski', englishName: 'Polish'),
    SupportedLanguage(locale: Locale('de'), nativeName: 'Deutsch', englishName: 'German'),
    SupportedLanguage(locale: Locale('fr'), nativeName: 'Français', englishName: 'French'),
    SupportedLanguage(locale: Locale('es'), nativeName: 'Español', englishName: 'Spanish'),
    SupportedLanguage(locale: Locale('it'), nativeName: 'Italiano', englishName: 'Italian'),
    SupportedLanguage(locale: Locale('pt'), nativeName: 'Português', englishName: 'Portuguese'),
    SupportedLanguage(locale: Locale('nl'), nativeName: 'Nederlands', englishName: 'Dutch'),
    SupportedLanguage(locale: Locale('ro'), nativeName: 'Română', englishName: 'Romanian'),
    SupportedLanguage(locale: Locale('bg'), nativeName: 'Български', englishName: 'Bulgarian'),
    SupportedLanguage(locale: Locale('tr'), nativeName: 'Türkçe', englishName: 'Turkish'),
    SupportedLanguage(locale: Locale('fil'), nativeName: 'Filipino', englishName: 'Filipino'),
    SupportedLanguage(locale: Locale('zh'), nativeName: '简体中文', englishName: 'Chinese Simplified'),
  ];

  static bool isSupported(Locale locale) {
    return values.any(
      (language) => language.locale.languageCode == locale.languageCode,
    );
  }

  static Locale fallbackLocale() {
    return const Locale('en');
  }
}
