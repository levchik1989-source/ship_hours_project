import 'package:flutter/material.dart';

import '../../../../domain/entities/work_slot.dart';

final class WorkSlotButton extends StatelessWidget {
  const WorkSlotButton({
    required this.label,
    required this.slot,
    required this.onPressed,
    super.key,
  });

  final String label;
  final WorkSlot slot;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isWorked = slot.isWorked;
    final background = !isWorked
        ? const Color(0xFF142033)
        : slot.isUkWaters
            ? const Color(0xFF18B83D)
            : const Color(0xFF1677D2);
    final foreground = !isWorked ? const Color(0xFF9CA3AF) : Colors.white;
    final border = !isWorked
        ? const Color(0xFF263348)
        : slot.isUkWaters
            ? const Color(0xFF22C55E)
            : const Color(0xFF38BDF8);
    /*
    final unused = switch (slot.state) {
      WorkSlotCategory.regular => (
          const Color(0xFF18B83D),
          Colors.white,
          const Color(0xFF22C55E),
        ),
      WorkSlotCategory.overtime => (
          const Color(0xFFFF8A00),
          Colors.white,
          const Color(0xFFFFA000),
        ),
      WorkSlotCategory.holiday => (
          const Color(0xFFFF3B1F),
          Colors.white,
          const Color(0xFFFF3B1F),
        ),
      WorkSlotCategory.rest => (
          const Color(0xFF142033),
          const Color(0xFF9CA3AF),
          const Color(0xFF263348),
        ),
    };
    */

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                background.withValues(alpha: 0.92),
                background.withValues(alpha: 0.72),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border.withValues(alpha: 0.55)),
            boxShadow: [
              if (isWorked)
                BoxShadow(
                  color: background.withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onPressed,
              child: SizedBox(
                height: 38,
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
