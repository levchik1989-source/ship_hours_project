import 'salary_profile.dart';

final class PayrollPeriod {
  const PayrollPeriod({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.profile,
    required this.travelAllowance,
    required this.canteenDeduction,
  });

  final String id;

  final DateTime startDate;
  final DateTime endDate;

  /// Копия профиля на момент создания периода.
  final SalaryProfile profile;

  /// Разовая выплата за период.
  final double travelAllowance;

  /// Удержание за столовую.
  final double canteenDeduction;

  PayrollPeriod copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    SalaryProfile? profile,
    double? travelAllowance,
    double? canteenDeduction,
  }) {
    return PayrollPeriod(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      profile: profile ?? this.profile,
      travelAllowance: travelAllowance ?? this.travelAllowance,
      canteenDeduction: canteenDeduction ?? this.canteenDeduction,
    );
  }
}
