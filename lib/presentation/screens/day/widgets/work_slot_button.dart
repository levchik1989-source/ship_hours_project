import 'package:flutter/material.dart';

import '../../../../core/enums/work_slot_state.dart';

final class WorkSlotButton extends StatelessWidget {
  const WorkSlotButton({
    required this.label,
    required this.state,
    required this.onPressed,
    super.key,
  });

  final String label;
  final WorkSlotState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isWorked = state == WorkSlotState.work;
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: isWorked ? scheme.primary : scheme.surfaceContainerHighest,
            foregroundColor: isWorked ? scheme.onPrimary : scheme.onSurface,
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
