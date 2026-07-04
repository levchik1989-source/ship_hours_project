final class MonthUtils {
  const MonthUtils._();

  static List<DateTime> calendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final start = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(42, (index) => start.add(Duration(days: index)));
  }

  static bool isCurrentMonth({required DateTime day, required DateTime month}) {
    return day.year == month.year && day.month == month.month;
  }

  static String monthKey(DateTime month) {
    final monthText = month.month.toString().padLeft(2, '0');
    return '${month.year}-$monthText';
  }
}
