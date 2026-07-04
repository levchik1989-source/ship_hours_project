import 'package:flutter/material.dart';

import '../../../../domain/services/hours_calculator.dart';
import 'work_slot_button.dart';

final class HourRow extends StatelessWidget {
  const HourRow({
    required this.hour,
    required this.firstCategory,
    required this.secondCategory,
    required this.onFirstTap,
    required this.onSecondTap,
    super.key,
  });

  final int hour;
  final WorkSlotCategory firstCategory;
  final WorkSlotCategory secondCategory;
  final VoidCallback onFirstTap;
  final VoidCallback onSecondTap;

  @override
  Widget build(BuildContext context) {
    final hourLabel = hour.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(hourLabel, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Row(
              children: [
                WorkSlotButton(label: ':00', category: firstCategory, onPressed: onFirstTap),
                WorkSlotButton(label: ':30', category: secondCategory, onPressed: onSecondTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
