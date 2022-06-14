import 'package:equatable/equatable.dart';

import '../model/match_result.dart';
import '../model/regexp_config.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class MatchRegex extends MatchEvent {
  final String regex;
  final String? content;
  final RegExpConfig config;
  final MatchInfo? selectMatch ;
  const MatchRegex({
    required this.regex,
    this.content,
    this.config = const RegExpConfig(),
    this.selectMatch
  });
}
