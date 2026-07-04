enum CurrencyType {
  usd,
  eur,
  gbp;

  String get symbol {
    switch (this) {
      case CurrencyType.usd:
        return r'$';
      case CurrencyType.eur:
        return '€';
      case CurrencyType.gbp:
        return '£';
    }
  }

  String get code {
    switch (this) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.eur:
        return 'EUR';
      case CurrencyType.gbp:
        return 'GBP';
    }
  }

  static CurrencyType fromName(String value) {
    return CurrencyType.values.firstWhere(
      (currency) => currency.name == value,
      orElse: () => CurrencyType.usd,
    );
  }
}
