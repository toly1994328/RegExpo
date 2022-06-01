import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:regexpo/src/content/model/match_result.dart';

abstract class MatchState extends Equatable {
  final InlineSpan span;
  const MatchState({this.span = const TextSpan(text: '')});

  @override
  List<Object?> get props => [];
}

class MatchSuccess extends MatchState {
  final List<MatchInfo> results;
  final int matchTime;

  const MatchSuccess({
    required this.results,
    this.matchTime = 0,
    InlineSpan span = const TextSpan(text: ''),
  }) : super(span: span);

  @override
  List<Object?> get props => [results];
}

class MatchError extends MatchState {
  final String error;

  const MatchError({
    required this.error,
    InlineSpan span = const TextSpan(text: ''),
  }) : super(span: span);

  @override
  List<Object?> get props => [error];
}
