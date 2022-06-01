import 'package:equatable/equatable.dart';

class UserSelection extends Equatable{
  final int activeLeftNavId;
  final int activeRightNavId;
  final int activeTabId;
  final int activeExampleId;
  final int recommendIndex;
  final String regex;

  const UserSelection({
    this.activeLeftNavId = 1,
    this.activeRightNavId = 0,
    this.activeTabId =0,
    this.activeExampleId =0,
    this.recommendIndex = 0,
    this.regex = '',
  });

  UserSelection copyWith({
    int? activeLeftNavId,
    int? activeRightNavId,
    int? activeTabId,
    int? activeExampleId,
    int? recommendIndex,
    String? regex,
  }) {
    return UserSelection(
      activeLeftNavId: activeLeftNavId ?? this.activeLeftNavId,
      activeRightNavId: activeRightNavId ?? this.activeRightNavId,
      activeTabId: activeTabId ?? this.activeTabId,
      recommendIndex: recommendIndex ?? this.recommendIndex,
      activeExampleId: activeExampleId ?? this.activeExampleId,
      regex: regex ?? this.regex,
    );
  }

  @override

  List<Object?> get props => [
    activeLeftNavId,
    activeRightNavId,
    activeTabId,
    recommendIndex,
    activeExampleId,
    regex,
  ];
}

