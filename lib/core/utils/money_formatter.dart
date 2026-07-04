import '../enums/currency_type.dart';

final class MoneyFormatter {
  const MoneyFormatter._();

  static String format({required double amount, required CurrencyType currency}) {
    return '${currency.symbol}${amount.toStringAsFixed(2)}';
  }
}
