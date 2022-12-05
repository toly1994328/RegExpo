import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:regexpo/src/models/models.dart';


abstract class RecordState extends Equatable {
  const RecordState();

  Record? get active {
    RecordState state = this;
    if (state is LoadedRecordState) {
      return state.activeRecord;
    }
    return null;
  }

  List<Record> get cacheRecord{
    RecordState state = this;
    if (state is LoadedRecordState) {
      return state.cacheTabs;
    }
    return [];
  }

  RecordState copyWith({
    List<Record>? records,
    List<Record>? cacheTabs,
    int? activeRecordId,
  }) {
    RecordState state = this;
    if (state is LoadedRecordState) {
      return LoadedRecordState(
        records: records ?? state.records,
        cacheTabs: cacheTabs ?? state.cacheTabs,
        activeRecordId: activeRecordId ?? state.activeRecordId,
      );
    } else {
      return state;
    }
  }

  @override
  List<Object?> get props => [];
}

class ErrorRecordState extends RecordState {
  final String error;

  const ErrorRecordState({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoadedRecordState extends RecordState {
  final List<Record> records;
  final List<Record> cacheTabs;
  final int activeRecordId;

  const LoadedRecordState({
    required this.records,
    required this.cacheTabs,
    required this.activeRecordId,
  });

  Record get activeRecord => records.singleWhere((e) => e.id == activeRecordId);

  int get nextActiveId {
    int targetIndex = records.indexOf(activeRecord);
    if(targetIndex==records.length-1){
      // 说明是最后一个，取前一个为激活索引
      return targetIndex - 1;
    }
    // 说明在中间，取下一个元素索引
    return targetIndex + 1;
  }

  int get nextCacheIndex {
    int targetIndex = cacheTabs.indexOf(activeRecord);
    if(targetIndex==cacheTabs.length-1){
      // 说明是最后一个，取前一个为激活索引
      return targetIndex - 1;
    }
    // 说明在中间，取下一个元素索引
    return targetIndex + 1;
  }

  @override
  List<Object?> get props => [activeRecordId, records, cacheTabs];
}

class EmptyRecordState extends RecordState {
  const EmptyRecordState();
}

class LoadingRecordState extends RecordState {
  const LoadingRecordState();
}
