import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';

import 'match_panel.dart';

class MatchContent extends StatelessWidget {
  const MatchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (_, s) {
        if (s is MatchSuccess) {
          return MatchListView(
            s.results,
            onSelectItem: (MatchInfo? info) {
              _onSelectItem(context, info);
            },
          );
        }
        return const ErrorPanel(
          data: "正则规则异常",
          icon: TolyIcon.zanwushuju,
          // onRefresh: bloc.loadRecord,
        );
      },
    );
  }

  void _onSelectItem(BuildContext context, MatchInfo? info) {
    context.read<MatchBloc>().add(HoverMatchRegex(matchInfo: info));
  }
}
