import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/models/models.dart';

import '../../models/link_regex/link_regex.dart';
import '../../repository/impl/db_link_regex_repository.dart';
import '../../repository/link_regex_repository.dart';
import 'link_regex_state.dart';


class LinkRegexBloc extends Cubit<LinkRegexState> {
  final LinkRegexRepository repository = const DbLinkRegexRepository();

  LinkRegexBloc() : super(const EmptyLinkRegexState());

  void loadLinkRegex({
    required int recordId,
    bool keepActive = false,
  }) async {
    LinkRegexState state;
    if(!keepActive){
      emit(const LoadingLinkRegexState());
    }
    // await Future.delayed(const Duration(milliseconds: 500));
    List<LinkRegex> results = [];
    try {
      // throw Exception("故意抛出异常");
      results = await repository.queryLinkRegexByRecordId(
          recordId: recordId
      );
      if (results.isNotEmpty) {
        state = LoadedLinkRegexState(
          activeLinkRegexId: _handleActiveId(results,keepActive),
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

  int _handleActiveId(List<LinkRegex> results, bool keepActive) {
    LinkRegexState state = this.state;
    int? activeId = state.activeRegex?.id;
    if(!keepActive) return results.first.id;
    if (state is LoadedLinkRegexState) {
      // 如果不是删除已激活的元素
      if (results.where((e) => e.id == activeId).isNotEmpty) {
        return activeId!;
      }
      return state.regexes[state.nextActiveIndex].id;
    }
    return -1;
  }

  Future<bool> deleteById(int id,Record? record) async{
    int result = await repository.deleteById(id);
    if(record==null) return false;
    if (result > 0) {
      loadLinkRegex(recordId: record.id,keepActive: true);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> insert(String regex,int recordId) async{
    int result = await repository.insert(LinkRegex.i(
        regex: regex,
        recordId: recordId
    ));
    if (result > 0) {
      loadLinkRegex(recordId: recordId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(LinkRegex record) async{
    int result = await repository.update(record);
    if (result > 0) {
      loadLinkRegex(recordId: record.recordId,keepActive: true);
      return true;
    } else {
      return false;
    }
  }

  void select(int id) {
    emit(state.copyWith(activeLinkRegexId: id));
  }
}
