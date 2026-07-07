import 'package:flutter/material.dart';

import '../../../../domain/entities/work_slot.dart';
import 'work_slot_button.dart';

final class HourRow extends StatelessWidget {
  const HourRow({
    required this.hour,
    required this.firstSlot,
    required this.secondSlot,
    required this.onFirstTap,
    required this.onSecondTap,
    super.key,
  });

  final int hour;
  final WorkSlot firstSlot;
  final WorkSlot secondSlot;
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
            child: Text(hourLabel,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Row(
              children: [
                WorkSlotButton(
                    label: ':00', slot: firstSlot, onPressed: onFirstTap),
                WorkSlotButton(
                    label: ':30', slot: secondSlot, onPressed: onSecondTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
