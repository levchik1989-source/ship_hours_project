import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../controllers/app_settings_controller.dart';
import 'widgets/currency_selector.dart';
import 'widgets/language_selector.dart';
import 'widgets/theme_selector.dart';
import '../salary_profiles/salary_profiles_screen.dart';

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final controller = context.watch<AppSettingsController>();
    final settings = controller.settings;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings), centerTitle: true),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: NavigationBar(
            height: 72,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(context).colorScheme.primaryContainer,
            elevation: 6,
            animationDuration: const Duration(milliseconds: 250),
            selectedIndex: 2,
            onDestinationSelected: (index) {
              if (index == 0) {
                Navigator.of(context).pushReplacementNamed(AppRouter.calendar);
              }
              if (index == 1) {
                Navigator.of(context).pushReplacementNamed(
                  AppRouter.statistics,
                  arguments: DateTime.now(),
                );
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded),
                label: 'Statistics',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SettingsSection(
            title: localizations.companyRules,
            children: [
              TextFormField(
                initialValue: settings.regularHours.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: localizations.regularHours),
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
                decoration:
                    InputDecoration(labelText: localizations.regularRate),
                onChanged: (value) {
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed != null && parsed >= 0) {
                    controller.updateRegularRate(parsed);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.baseSalary.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: localizations.baseSalary),
                onChanged: (value) {
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed != null && parsed >= 0) {
                    controller.updateBaseSalary(parsed);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.overtimeRate.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: localizations.overtimeRate),
                onChanged: (value) {
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed != null && parsed >= 0) {
                    controller.updateOvertimeRate(parsed);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.holidayRate.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: localizations.holidayRate),
                onChanged: (value) {
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed != null && parsed >= 0) {
                    controller.updateHolidayRate(parsed);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: settings.periodStartDay.toString(),
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: localizations.periodStartDay),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed >= 1 && parsed <= 31) {
                    controller.updatePeriodStartDay(parsed);
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
            title: localizations.fixedOvertime,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: settings.fixedOvertimeEnabled,
                title: Text(localizations.fixedOvertimeEnabled),
                subtitle: Text(localizations.fixedOvertimeHint),
                onChanged: controller.updateFixedOvertimeEnabled,
              ),
              if (settings.fixedOvertimeEnabled) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: settings.fixedOvertimeHours.toStringAsFixed(
                      settings.fixedOvertimeHours % 1 == 0 ? 0 : 1),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: localizations.fixedOvertimeHours),
                  onChanged: (value) {
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed != null && parsed >= 0) {
                      controller.updateFixedOvertimeHours(parsed);
                    }
                  },
                ),
              ],
            ],
          ),
          _SettingsSection(
            title: localizations.companyHolidays,
            children: [
              if (settings.companyHolidays.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(localizations.noHolidays,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ...settings.companyHolidays.map((holiday) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.celebration_outlined),
                    title: Text(DateFormat.yMMMd(
                            Localizations.localeOf(context).toLanguageTag())
                        .format(holiday)),
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
          CurrencySelector(
              value: settings.currency, onChanged: controller.updateCurrency),
          ThemeSelector(
              value: settings.themeMode, onChanged: controller.updateThemeMode),
          LanguageSelector(
              value: settings.locale, onChanged: controller.updateLocale),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Salary Profiles'),
              subtitle: const Text('Create and manage salary profiles'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SalaryProfilesScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(localizations.about),
              subtitle: const Text('Created by LEVCHIK'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed(AppRouter.about),
            ),
          ),
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
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

final class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile(
      {required this.label, required this.value, required this.onChanged});

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final valueText =
        value == null ? l.notSet : DateFormat.yMMMd(locale).format(value!);

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
