import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/selection_cubic.dart';
import '../bloc/tab_cubic.dart';
import '../model/selection.dart';
import '../model/tab_bean.dart';

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: BlocBuilder<SelectionCubit, Selection>(
          buildWhen: (p,n)=>p.activeTabIndex!=n.activeTabIndex,
          builder: (_, selection) => BlocBuilder<TabCubit, TabList>(
              builder: (ctx, state) => buildByState(ctx, state, selection))),
    );
  }

  Widget buildByState(BuildContext ctx, TabList state, Selection selection) {
    if(state.tabs.isEmpty) return Text('暂无数据');
    // return LocalTerminal();
    return Text(state.tabs[selection.activeTabIndex].content);

  }
}
