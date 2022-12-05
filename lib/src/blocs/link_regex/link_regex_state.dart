import 'package:equatable/equatable.dart';

import '../../models/models.dart';


abstract class LinkRegexState extends Equatable {
  const LinkRegexState();

  LinkRegex? get activeRegex {
    LinkRegexState state = this;
    if (state is LoadedLinkRegexState) {
      if(state.activeLinkRegexId==-1) return LinkRegex.i(regex: '', recordId: -1);
      return state.activeLinkRegex;
    }
    return null;
  }

  LinkRegexState copyWith({
    List<LinkRegex>? records,
    int? activeLinkRegexId,
  }) {
    LinkRegexState state = this;
    if (state is LoadedLinkRegexState) {
      return LoadedLinkRegexState(
        regexes: records ?? state.regexes,
        activeLinkRegexId: activeLinkRegexId ?? state.activeLinkRegexId,
      );
    } else {
      return state;
    }
  }

  @override
  List<Object?> get props => [];
}

class ErrorLinkRegexState extends LinkRegexState {
  final String error;

  const ErrorLinkRegexState({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoadedLinkRegexState extends LinkRegexState {
  final List<LinkRegex> regexes;
  final int activeLinkRegexId;

  const LoadedLinkRegexState({
    required this.regexes,
    required this.activeLinkRegexId,
  });

  LinkRegex get activeLinkRegex => regexes.singleWhere((e) => e.id == activeLinkRegexId);

  int get nextActiveIndex {
    int targetIndex = regexes.indexOf(activeLinkRegex);
    if(targetIndex==regexes.length-1){
      // 说明是最后一个，取前一个为激活索引
      return targetIndex - 1;
    }
    // 说明在中间，取下一个元素索引
    return targetIndex + 1;
  }

  @override
  List<Object?> get props => [activeLinkRegexId, regexes];
}

class EmptyLinkRegexState extends LinkRegexState {
  const EmptyLinkRegexState();
}

class LoadingLinkRegexState extends LinkRegexState {
  const LoadingLinkRegexState();
}
