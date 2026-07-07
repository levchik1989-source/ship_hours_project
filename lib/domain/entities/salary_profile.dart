final class SalaryProfile {
  const SalaryProfile({
    required this.id,
    required this.name,
    required this.basicUk,
    required this.basicNonUk,
    required this.leaveUk,
    required this.leaveNonUk,
    required this.guaranteedOtUk,
    required this.guaranteedOtNonUk,
    required this.extraOtUkRate,
    required this.extraOtNonUkRate,
    required this.standardWorkDay,
    required this.lashingBonus,
  });

  final String id;
  final String name;

  final double basicUk;
  final double basicNonUk;

  final double leaveUk;
  final double leaveNonUk;

  final double guaranteedOtUk;
  final double guaranteedOtNonUk;

  final double extraOtUkRate;
  final double extraOtNonUkRate;

  final double standardWorkDay;
  final double lashingBonus;

  SalaryProfile copyWith({
    String? id,
    String? name,
    double? basicUk,
    double? basicNonUk,
    double? leaveUk,
    double? leaveNonUk,
    double? guaranteedOtUk,
    double? guaranteedOtNonUk,
    double? extraOtUkRate,
    double? extraOtNonUkRate,
    double? standardWorkDay,
    double? lashingBonus,
  }) {
    return SalaryProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      basicUk: basicUk ?? this.basicUk,
      basicNonUk: basicNonUk ?? this.basicNonUk,
      leaveUk: leaveUk ?? this.leaveUk,
      leaveNonUk: leaveNonUk ?? this.leaveNonUk,
      guaranteedOtUk: guaranteedOtUk ?? this.guaranteedOtUk,
      guaranteedOtNonUk: guaranteedOtNonUk ?? this.guaranteedOtNonUk,
      extraOtUkRate: extraOtUkRate ?? this.extraOtUkRate,
      extraOtNonUkRate: extraOtNonUkRate ?? this.extraOtNonUkRate,
      standardWorkDay: standardWorkDay ?? this.standardWorkDay,
      lashingBonus: lashingBonus ?? this.lashingBonus,
    );
  }
}
