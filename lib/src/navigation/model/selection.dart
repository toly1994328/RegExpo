class Selection {
  final int activeLeftNavId;
  final int activeRightNavId;
  final int activeTabIndex;

  Selection({
    this.activeLeftNavId = 1,
    this.activeRightNavId = 0,
    this.activeTabIndex =0,
  });

  Selection copyWith({
    int? activeLeftNavId,
    int? activeRightNavId,
    int? activeTabIndex,
  }) {
    return Selection(
      activeLeftNavId: activeLeftNavId ?? this.activeLeftNavId,
      activeRightNavId: activeRightNavId ?? this.activeRightNavId,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }
}

