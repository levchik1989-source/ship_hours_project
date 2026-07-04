final class MonthStatistics {
  const MonthStatistics({
    required this.regularHours,
    required this.overtimeHours,
    required this.totalHours,
    required this.regularPay,
    required this.overtimePay,
    required this.totalPay,
  });

  final double regularHours;
  final double overtimeHours;
  final double totalHours;
  final double regularPay;
  final double overtimePay;
  final double totalPay;
}
