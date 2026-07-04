import 'package:flutter/material.dart';

import '../presentation/screens/calendar/calendar_screen.dart';
import '../presentation/screens/day/day_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/statistics/statistics_screen.dart';

final class AppRouter {
  const AppRouter();

  static const String calendar = '/';
  static const String day = '/day';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  Route<void> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? calendar;

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        switch (routeName) {
          case calendar:
            return const CalendarScreen();
          case day:
            return DayScreen(
              selectedDate: settings.arguments! as DateTime,
            );
          case statistics:
            return StatisticsScreen(
              selectedMonth: settings.arguments! as DateTime,
            );
          case AppRouter.settings:
            return const SettingsScreen();
          default:
            return const CalendarScreen();
        }
      },
    );
  }
}
