import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          _SettingsSection(
            title: localizations.contract,
            children: [
              TextFormField(
                initialValue: settings.companyName,
                decoration: InputDecoration(labelText: localizations.company),
                onChanged: controller.updateCompanyName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.vesselName,
                decoration: InputDecoration(labelText: localizations.vessel),
                onChanged: controller.updateVesselName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.rank,
                decoration: InputDecoration(labelText: localizations.rank),
                onChanged: controller.updateRank,
              ),
              const SizedBox(height: 12),
              _DatePickerTile(label: localizations.contractStart, value: settings.contractStartDate, onChanged: controller.updateContractStartDate),
              _DatePickerTile(label: localizations.contractEnd, value: settings.contractEndDate, onChanged: controller.updateContractEndDate),
            ],
          ),
          _SettingsSection(
            title: localizations.companyRules,
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
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: settings.weekendOvertimeEnabled,
                title: Text(localizations.weekendOvertime),
                onChanged: controller.updateWeekendOvertimeEnabled,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: settings.moveWeekendHolidayToNextWorkday,
                title: Text(localizations.moveWeekendHoliday),
                onChanged: controller.updateMoveWeekendHolidayToNextWorkday,
              ),
            ],
          ),
          _SettingsSection(
            title: localizations.companyHolidays,
            children: [
              if (settings.companyHolidays.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(localizations.noHolidays, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ...settings.companyHolidays.map((holiday) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.celebration_outlined),
                    title: Text(DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(holiday)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => controller.removeCompanyHoliday(holiday),
                    ),
                  )),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) {
                    await controller.addCompanyHoliday(picked);
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(localizations.addHoliday),
              ),
            ],
          ),
          CurrencySelector(value: settings.currency, onChanged: controller.updateCurrency),
          ThemeSelector(value: settings.themeMode, onChanged: controller.updateThemeMode),
          LanguageSelector(value: settings.locale, onChanged: controller.updateLocale),
        ],
      ),
    );
  }
}

final class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

final class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final valueText = value == null ? l.notSet : DateFormat.yMMMd(locale).format(value!);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(valueText),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => onChanged(null),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                initialDate: value ?? DateTime.now(),
              );
              if (picked != null) onChanged(picked);
            },
          ),
        ],
      ),
    );
  }
}
