import '../entities/app_settings.dart';

final class CompanyRulesService {
  const CompanyRulesService._();

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isCompanyHoliday(DateTime date, AppSettings settings) {
    return settings.companyHolidays.any((holiday) => _sameDay(holiday, date));
  }

  static bool isObservedHoliday(DateTime date, AppSettings settings) {
    if (isCompanyHoliday(date, settings)) return true;
    if (!settings.moveWeekendHolidayToNextWorkday) return false;

    for (final holiday in settings.companyHolidays) {
      final observed = observedDateForHoliday(holiday, settings);
      if (_sameDay(observed, date)) return true;
    }
    return false;
  }

  static DateTime observedDateForHoliday(DateTime holiday, AppSettings settings) {
    final normalized = DateTime(holiday.year, holiday.month, holiday.day);
    if (!settings.moveWeekendHolidayToNextWorkday || !isWeekend(normalized)) {
      return normalized;
    }

    var date = normalized.add(const Duration(days: 1));
    while (isWeekend(date)) {
      date = date.add(const Duration(days: 1));
    }
    return DateTime(date.year, date.month, date.day);
  }

  static bool isOvertimeDay(DateTime date, AppSettings settings) {
    return settings.weekendOvertimeEnabled && isWeekend(date);
  }

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
