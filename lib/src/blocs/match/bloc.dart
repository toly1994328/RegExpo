import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs.dart';
import 'package:regexpo/src/repositories/parser/regex_parser.dart';


class MatchBloc extends Bloc<MatchEvent, MatchState> {
  RegexParser parser = RegexParser();

  MatchBloc() : super(const MatchSuccess()) {
    on<ChangeRegex>(_onChangeRegex);
    on<ChangeContent>(_onChangeContent);
    on<HoverMatchRegex>(_onHoverMatchRegex);
    on<UpdateRegexConfig>(_onUpdateRegexConfig);
    on<ReplaceText>(_onReplaceText);
  }

  void _onChangeRegex(ChangeRegex event, Emitter<MatchState> emit){
    MatchState match = parser.match(
      state.content,
      event.pattern,
      state.config,
    );
    emit(match);
  }

  void _onHoverMatchRegex(HoverMatchRegex event, Emitter<MatchState> emit) {
    MatchState match = parser.match(
      state.content,
      state.pattern,
      state.config,
      activeMatch: event.matchInfo,
    );
    emit(match);
  }

  void _onChangeContent(ChangeContent event, Emitter<MatchState> emit) {
    MatchState match = parser.match(
      event.content,
      state.pattern,
      state.config,
    );
    emit(match);
  }

  void _onUpdateRegexConfig(UpdateRegexConfig event, Emitter<MatchState> emit) {
    MatchState match = parser.match(
      state.content,
      state.pattern,
      event.config,
    );
    emit(match);
  }

  void _onReplaceText(ReplaceText event, Emitter<MatchState> emit) {
    try {
      RegExp regex = RegExp(
        state.pattern,
        multiLine: state.config.multiLine,
        caseSensitive: state.config.caseSensitive,
        unicode: state.config.unicode,
        dotAll: state.config.dotAll,
      );
      String replacedContent = state.content.replaceAll(regex, event.replacement);
      MatchState match = parser.match(
        replacedContent,
        state.pattern,
        state.config,
      );
      emit(match);
    } catch (e) {
      emit(MatchError(error: e.toString()));
    }
  }
}
