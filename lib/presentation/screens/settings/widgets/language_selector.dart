import 'package:flutter/material.dart';

import '../../../../core/constants/supported_languages.dart';
import '../../../../l10n/app_localizations.dart';

final class LanguageSelector extends StatelessWidget {
  const LanguageSelector(
      {required this.value, required this.onChanged, super.key});

  final Locale value;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<Locale>(
          initialValue: _normalizedValue(),
          decoration: InputDecoration(labelText: localizations.language),
          items: SupportedLanguages.values.map((language) {
            return DropdownMenuItem<Locale>(
                value: language.locale, child: Text(language.nativeName));
          }).toList(),
          onChanged: (locale) {
            if (locale != null) {
              onChanged(locale);
            }
          },
        ),
      ),
    );
  }

  Locale _normalizedValue() {
    for (final language in SupportedLanguages.values) {
      if (language.locale.languageCode == value.languageCode) {
        return language.locale;
      }
    }
    return SupportedLanguages.fallbackLocale();
  }
}
