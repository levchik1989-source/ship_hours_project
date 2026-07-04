import 'package:flutter/material.dart';

import '../../../../core/enums/currency_type.dart';
import '../../../../l10n/app_localizations.dart';

final class CurrencySelector extends StatelessWidget {
  const CurrencySelector({required this.value, required this.onChanged, super.key});

  final CurrencyType value;
  final ValueChanged<CurrencyType> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<CurrencyType>(
          value: value,
          decoration: InputDecoration(labelText: localizations.currency),
          items: CurrencyType.values.map((currency) {
            return DropdownMenuItem<CurrencyType>(value: currency, child: Text('${currency.symbol} ${currency.code}'));
          }).toList(),
          onChanged: (currency) {
            if (currency != null) {
              onChanged(currency);
            }
          },
        ),
      ),
    );
  }
}
