import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/work_hours_repository.dart';
import '../domain/repositories/salary_profile_repository.dart';
import '../l10n/app_localizations.dart';
import '../presentation/controllers/app_settings_controller.dart';
import '../presentation/controllers/calendar_controller.dart';
import '../presentation/controllers/salary_profile_controller.dart';
import 'app_bootstrap.dart';
import 'app_router.dart';

final class ShipHoursApp extends StatelessWidget {
  ShipHoursApp({
    required this.dependencies,
    super.key,
  });

  final AppDependencies dependencies;
  final AppRouter _router = const AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(
          value: dependencies.settingsRepository,
        ),
        Provider<SalaryProfileRepository>.value(
          value: dependencies.salaryProfileRepository,
        ),
        Provider<WorkHoursRepository>.value(
          value: dependencies.workHoursRepository,
        ),
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController(
            repository: dependencies.settingsRepository,
          )..load(),
        ),
        ChangeNotifierProvider<SalaryProfileController>(
          create: (context) => SalaryProfileController(
            repository: context.read<SalaryProfileRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider<CalendarController>(
          create: (_) => CalendarController(
            repository: dependencies.workHoursRepository,
          )..loadCurrentMonth(),
        ),
      ],
      child: Consumer<AppSettingsController>(
        builder: (context, controller, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ship Hours',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: controller.settings.themeMode,
            locale: controller.settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: AppRouter.calendar,
            onGenerateRoute: _router.onGenerateRoute,
          );
        },
      ),
    );
  }
}
