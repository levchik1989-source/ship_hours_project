enum WorkSlotState {
  rest,
  work;

  bool get isWork => this == WorkSlotState.work;

  WorkSlotState toggled() {
    switch (this) {
      case WorkSlotState.rest:
        return WorkSlotState.work;
      case WorkSlotState.work:
        return WorkSlotState.rest;
    }
  }

  static WorkSlotState fromName(String value) {
    return WorkSlotState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => WorkSlotState.rest,
    );
  }
}
