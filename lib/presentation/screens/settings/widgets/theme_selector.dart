import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

final class ThemeSelector extends StatelessWidget {
  const ThemeSelector(
      {required this.value, required this.onChanged, super.key});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<ThemeMode>(
          initialValue: value,
          decoration: InputDecoration(labelText: localizations.theme),
          items: [
            DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(localizations.systemTheme)),
            DropdownMenuItem(
                value: ThemeMode.light, child: Text(localizations.lightTheme)),
            DropdownMenuItem(
                value: ThemeMode.dark, child: Text(localizations.darkTheme)),
          ],
          onChanged: (themeMode) {
            if (themeMode != null) {
              onChanged(themeMode);
            }
          },
        ),
      ),
    );
  }
}
