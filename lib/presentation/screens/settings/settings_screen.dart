import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import 'widgets/currency_selector.dart';
import 'widgets/language_selector.dart';
import 'widgets/theme_selector.dart';

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final controller = context.watch<AppSettingsController>();
    final settings = controller.settings;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: settings.regularHours.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: localizations.regularHours),
                    onChanged: (value) {
                      final parsed = double.tryParse(value.replaceAll(',', '.'));
                      if (parsed != null && parsed >= 0 && parsed <= 24) {
                        controller.updateRegularHours(parsed);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: settings.regularRate.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: localizations.regularRate),
                    onChanged: (value) {
                      final parsed = double.tryParse(value.replaceAll(',', '.'));
                      if (parsed != null && parsed >= 0) {
                        controller.updateRegularRate(parsed);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: settings.overtimeRate.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: localizations.overtimeRate),
                    onChanged: (value) {
                      final parsed = double.tryParse(value.replaceAll(',', '.'));
                      if (parsed != null && parsed >= 0) {
                        controller.updateOvertimeRate(parsed);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          CurrencySelector(value: settings.currency, onChanged: controller.updateCurrency),
          ThemeSelector(value: settings.themeMode, onChanged: controller.updateThemeMode),
          LanguageSelector(value: settings.locale, onChanged: controller.updateLocale),
        ],
      ),
    );
  }
}
