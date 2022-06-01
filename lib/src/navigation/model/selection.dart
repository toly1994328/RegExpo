class UserSelection {
  final int activeLeftNavId;
  final int activeRightNavId;
  final int activeTabId;
  final int activeExampleId;
  final String regex;

  UserSelection({
    this.activeLeftNavId = 1,
    this.activeRightNavId = 0,
    this.activeTabId =0,
    this.activeExampleId =0,
    this.regex ='',
  });

  UserSelection copyWith({
    int? activeLeftNavId,
    int? activeRightNavId,
    int? activeTabId,
    int? activeExampleId,
    String? regex,
  }) {
    return UserSelection(
      activeLeftNavId: activeLeftNavId ?? this.activeLeftNavId,
      activeRightNavId: activeRightNavId ?? this.activeRightNavId,
      activeTabId: activeTabId ?? this.activeTabId,
      activeExampleId: activeExampleId ?? this.activeExampleId,
      regex: regex ?? this.regex,
    );
  }
}

