final class MonthStatistics {
  const MonthStatistics({
    required this.regularHours,
    required this.overtimeHours,
    required this.holidayHours,
    required this.totalHours,
    required this.regularPay,
    required this.overtimePay,
    required this.holidayPay,
    required this.totalPay,
  });

  final double regularHours;
  final double overtimeHours;
  final double holidayHours;
  final double totalHours;
  final double regularPay;
  final double overtimePay;
  final double holidayPay;
  final double totalPay;
}
