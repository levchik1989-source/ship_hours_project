import 'package:flutter/material.dart';

import '../../../../domain/services/hours_calculator.dart';

final class WorkSlotButton extends StatelessWidget {
  const WorkSlotButton({
    required this.label,
    required this.category,
    required this.onPressed,
    super.key,
  });

  final String label;
  final WorkSlotCategory category;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (category) {
      WorkSlotCategory.regular => (const Color(0xFF2E7D32), Colors.white),
      WorkSlotCategory.overtime => (const Color(0xFFFFA000), Colors.black),
      WorkSlotCategory.holiday => (const Color(0xFFD84315), Colors.white),
      WorkSlotCategory.rest => (scheme.surfaceContainerHighest, scheme.onSurface),
    };

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            minimumSize: const Size.fromHeight(34),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,
          child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
