class UserSelection {
  final int activeLeftNavId;
  final int activeRightNavId;
  final int activeTabId;
  final int activeExampleId;

  UserSelection({
    this.activeLeftNavId = 1,
    this.activeRightNavId = 0,
    this.activeTabId =0,
    this.activeExampleId =0,
  });

  UserSelection copyWith({
    int? activeLeftNavId,
    int? activeRightNavId,
    int? activeTabId,
    int? activeExampleId,
  }) {
    return UserSelection(
      activeLeftNavId: activeLeftNavId ?? this.activeLeftNavId,
      activeRightNavId: activeRightNavId ?? this.activeRightNavId,
      activeTabId: activeTabId ?? this.activeTabId,
      activeExampleId: activeExampleId ?? this.activeExampleId,
    );
  }
}

