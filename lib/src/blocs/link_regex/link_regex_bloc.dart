import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/link_regex/link_regex.dart';
import '../../repository/impl/db_link_regex_repository.dart';
import '../../repository/link_regex_repository.dart';
import 'link_regex_state.dart';


class LinkRegexBloc extends Cubit<LinkRegexState> {
  final LinkRegexRepository repository = const DbLinkRegexRepository();

  LinkRegexBloc() : super(const EmptyLinkRegexState());

  void loadLinkRegex({
    required int recordId,
  }) async {
    LinkRegexState state;
    emit(const LoadingLinkRegexState());
    // await Future.delayed(const Duration(milliseconds: 500));
    List<LinkRegex> results = [];
    try {
      // throw Exception("故意抛出异常");
      results = await repository.queryLinkRegexByRecordId(
          recordId: recordId
      );
      if (results.isNotEmpty) {
        state = LoadedLinkRegexState(
          activeLinkRegexId: results.first.id,
          regexes: results,
        );
      } else {
        state = const EmptyLinkRegexState();
      }
    } catch (e) {
      debugPrint(e.toString());
      state = ErrorLinkRegexState(error: e.toString());
    }
    emit(state);
  }


  void select(int id) {
    emit(state.copyWith(activeLinkRegexId: id));
  }
}
