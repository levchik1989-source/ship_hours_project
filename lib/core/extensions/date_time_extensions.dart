extension DateTimeExtensions on DateTime {
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  DateTime get firstDayOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get lastDayOfMonth {
    return DateTime(year, month + 1, 0);
  }

  String get hiveKey {
    final monthText = month.toString().padLeft(2, '0');
    final dayText = day.toString().padLeft(2, '0');
    return '$year-$monthText-$dayText';
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime addMonths(int value) {
    return DateTime(year, month + value, 1);
  }

  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }
}
