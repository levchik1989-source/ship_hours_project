extension DurationExtensions on Duration {
  double get hours {
    return inMinutes / 60.0;
  }

  int get halfHourSlots {
    return (inMinutes / 30).round();
  }

  String get hhmm {
    final totalHours = inHours;
    final minutes = inMinutes.remainder(60);
    return '${totalHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

extension DoubleHoursFormatting on double {
  String get hoursText {
    if (truncateToDouble() == this) {
      return toInt().toString();
    }
    return toStringAsFixed(1);
  }
}
