import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:regexpo/src/blocs/blocs.dart';

import '../../models/record/record.dart';
import '../../repositories/impl/db_recode_repository.dart';
import '../../repositories/recode_repository.dart';

enum LoadType {
  load, // 加载
  refresh, // 更新
  delete, // 删除
  edit, // 编辑
  add, // 添加
  more, // 加载更多
}

class RecordBloc extends Cubit<RecordState> {
  final RecoderRepository repository = const DbRecoderRepository();

  RecordBloc() : super(const EmptyRecordState());

  void loadRecord({
    LoadType operation = LoadType.load,
  }) async {
    RecordState state;
    try {
      if (operation == LoadType.load) {
        emit(const LoadingRecordState());
        // 模拟耗时
        // await Future.delayed(const Duration(milliseconds: 500));
      }
      // int a = 1 ~/ 0; // 模拟异常
      List<Record> records = [];
      if (operation == LoadType.more) {
        records = await _loadMore();
      } else if (operation == LoadType.load) {
        records = await repository.search();
      } else {
        records = await _loadRefresh();
      }
      if (records.isNotEmpty) {
        state = LoadedRecordState(
          cacheTabs: _handleCacheTabs(records, operation),
          activeRecordId: _handleActiveId(records, operation),
          records: records,
        );
      } else {
        state = const EmptyRecordState();
      }
    } catch (e) {
      debugPrint(e.toString());
      state = ErrorRecordState(error: e.toString());
    }
    emit(state);
  }

  Future<bool> deleteById(int id) async {
    int result = await repository.deleteById(id);
    if (result > 0) {
      loadRecord(operation: LoadType.delete);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> openFile(File file) async {
    String content = file.readAsStringSync();
    if (content.length > 1500) {
      content = content.substring(0, 1500);
    }
    bool result = await insert(
      path.basenameWithoutExtension(file.path),
      content,
    );
    if (result) {
      loadRecord(operation: LoadType.add);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> insert(String title, String content) async {
    int result = await repository.insert(Record.i(
      title: title,
      content: content,
    ));
    if (result > 0) {
      loadRecord(operation: LoadType.add);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(Record record) async {
    int result = await repository.update(record);
    if (result > 0) {
      loadRecord(operation: LoadType.edit);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Record>> _loadRefresh() async {
    int length = 0;
    if (state is! LoadedRecordState) {
      length = 25;
    } else {
      LoadedRecordState oldState = state as LoadedRecordState;
      length = max(oldState.records.length, 25);
    }

    List<Record> records = await repository.search(
      page: 1,
      pageSize: length,
    );
    return records;
  }

  Future<List<Record>> _loadMore() async {
    List<Record> records = [];
    if (state is! LoadedRecordState) return records;
    LoadedRecordState oldState = state as LoadedRecordState;
    int pageSize = 25;
    int pageIndex = oldState.records.length ~/ pageSize;
    if (pageIndex < 1) return oldState.records;
    List<Record> newRecords = await repository.search(
      page: pageIndex + 1,
      pageSize: pageSize,
    );
    if (newRecords.isNotEmpty) {
      records = List.of(oldState.records)..addAll(newRecords);
    } else {
      records = oldState.records;
    }
    return records;
  }

  int _handleActiveId(List<Record> records, LoadType operation) {
    RecordState state = this.state;
    int? activeId = state.active?.id;
    switch (operation) {
      case LoadType.load:
      case LoadType.add:
        return records.first.id;
      case LoadType.refresh:
      case LoadType.more:
      case LoadType.edit:
        return activeId ?? records.first.id;
      case LoadType.delete:
        if (state is LoadedRecordState) {
          // 如果不是删除已激活的元素
          if (records.where((e) => e.id == activeId).isNotEmpty) {
            return activeId!;
          }
          return state.records[state.nextActiveId].id;
        }
        return -1;
    }
  }

  void select(int id) {
    if(state.active?.id==id) return;
    if(state is! LoadedRecordState) return;
    LoadedRecordState _state = state as LoadedRecordState;
    // 维护 cache tab
    List<Record> cache = _state.cacheRecord;
    List<Record> containsList = cache.where((e) => e.id==id).toList();
    if(containsList.isNotEmpty){
      //缓存包含激活记录，将记录移到缓存首位
      cache.removeWhere((e) => e.id==id);
      cache.insert(0, containsList.first);
    }else{
      Record record = _state.records.where((e) => e.id==id).first;
      cache.insert(0, record);
    }
    emit(state.copyWith(activeRecordId: id));
  }

  void selectCacheTab(int id) {
    if(state.active?.id==id) return;
    if(state is! LoadedRecordState) return;
    emit(state.copyWith(activeRecordId: id));
  }

  void removeCacheTab(int id) {
    if(state is! LoadedRecordState) return;
    LoadedRecordState _state = state as LoadedRecordState;
    if(_state.cacheTabs.length==1) return;
    int activeRecordId = _state.activeRecordId;
    List<Record> cache = List.of(state.cacheRecord);
    cache.removeWhere((e) => e.id == id);
    if(_state.activeRecordId == id){
      //当前激活索引被删除
      activeRecordId = _state.nextCacheId;
    }

    RecordState newState = state.copyWith(
        activeRecordId: activeRecordId,
        cacheTabs: cache
    );
    emit(newState);
  }

  List<Record> _handleCacheTabs(List<Record> records, LoadType operation) {
    List<Record> cache = state.cacheRecord;
    switch(operation){
      case LoadType.load:
      case LoadType.refresh:
      case LoadType.more:
        if(cache.isNotEmpty){
        return cache;
      }else{
        return [records.first];
      }
      case LoadType.add:
       return  [records.first,...List.of(cache)];
      case LoadType.delete:
      //如果删除的是已激活页签，需要清除 cache 中的对应元素
      if(state is LoadedRecordState){
        LoadedRecordState state = this.state as LoadedRecordState;
        Record nextActiveRecord = state.records[state.nextActiveId];
        cache.removeWhere((e) => e.id==state.activeRecordId||e.id==nextActiveRecord.id);
        return [nextActiveRecord,...List.of(cache)];
      }
      break;
      case LoadType.edit:
        int activeId = state.active?.id??records.first.id;
        int targetIndex = cache.lastIndexWhere((e) => e.id==activeId);
        if(targetIndex!=-1){
          // 修改的记录包含在缓存中
          List<Record> editCache = List.of(cache);
          Record current = records.where((e) => e.id==activeId).first;
          editCache.removeAt(targetIndex);
          editCache.insert(targetIndex,current);
          return editCache;
        }
        break;
    }
    return [records.first];
  }
}
