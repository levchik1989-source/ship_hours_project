final class AppConstants {
  const AppConstants._();

  static const String appName = 'Ship Hours';

  static const int hoursPerDay = 24;
  static const int slotsPerHour = 2;
  static const int minutesPerSlot = 30;
  static const int totalSlotsPerDay = hoursPerDay * slotsPerHour;

  static const double defaultRegularHours = 8;
  static const double defaultRegularRate = 0;
  static const double defaultOvertimeRate = 0;
}
