import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs.dart';
import 'package:regexpo/src/repository/parser/regex_parser.dart';


class MatchBloc extends Bloc<MatchEvent, MatchState> {
  RegexParser parser = RegexParser();

  MatchBloc() : super(const MatchSuccess()) {
    on<ChangeRegex>(_onChangeRegex);
    on<ChangeContent>(_onChangeContent);
    on<HoverMatchRegex>(_onHoverMatchRegex);
    on<UpdateRegexConfig>(_onUpdateRegexConfig);
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
}
