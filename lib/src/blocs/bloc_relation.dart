import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';

import '../models/models.dart';

class BlocRelation extends StatelessWidget {
  final Widget child;

  const BlocRelation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RecordBloc, RecordState>(
          listenWhen: (p, n) =>
              p.active != n.active || p.runtimeType != n.runtimeType,
          listener: _listenRecordState,
        ),
        BlocListener<LinkRegexBloc, LinkRegexState>(
          listener: _listenLinkRegexChange,
        )
      ],
      child: child,
    );
  }

  void _listenLinkRegexChange(BuildContext context, LinkRegexState state) {
    if (state is LoadedLinkRegexState) {
      LinkRegex? regex = state.activeRegex;
      MatchBloc matchBloc = context.read<MatchBloc>();
      String pattern = '';
      if (regex != null) {
        if (regex.id != -1) {
          pattern = regex.regex;
        }
      }
      matchBloc.add(ChangeRegex(pattern: pattern));
    }
  }

  void _listenRecordState(BuildContext context, RecordState state) {
    LinkRegexBloc linkRegexBloc = context.read<LinkRegexBloc>();
    MatchBloc matchBloc = context.read<MatchBloc>();
    if (state is LoadedRecordState) {
      linkRegexBloc.loadLinkRegex(recordId: state.activeRecordId);
      String content = state.activeRecord.content;
      matchBloc.add(ChangeContent(content: content));
    }
    if (state is EmptyRecordState) {
      linkRegexBloc.loadLinkRegex(recordId: -1);
      matchBloc.add(const ChangeContent(content: ""));
    }
  }
}
