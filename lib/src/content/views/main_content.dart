import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/content/bloc/bloc.dart';
import 'package:regexpo/src/content/bloc/state.dart';

import '../../navigation/bloc/selection_cubic.dart';
import '../../navigation/bloc/tab_cubic.dart';
import '../../navigation/model/selection.dart';
import '../../navigation/model/tab_bean.dart';

class MainContent extends StatefulWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: BlocBuilder<SelectionCubit, UserSelection>(
        buildWhen: (p, n) => p.activeTabId != n.activeTabId,
        builder: (_, selection) => BlocBuilder<TabCubit, TabList>(
            builder: (ctx, state) => buildByState(ctx, state, selection)),
      ),
    );
  }

  Widget buildByState(BuildContext ctx, TabList state, UserSelection selection) {
    if(state.tabs.isEmpty) return Text('暂无内容');
    return ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<MatchBloc, MatchState>(
              builder: (_, s) => Text.rich(s.span),
            ),
          ),
        ),
      ] ,
    );
  }
}

