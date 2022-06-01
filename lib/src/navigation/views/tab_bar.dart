import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/content/bloc/bloc.dart';
import 'package:regexpo/src/content/bloc/event.dart';
import 'package:regexpo/src/directory/bloc/bloc.dart';
import 'package:regexpo/src/directory/bloc/state.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';

import '../bloc/bloc_exp.dart';
import '../bloc/tab_cubic.dart';

class MultiTabBar extends StatelessWidget {
  const MultiTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffF2F2F2),
        height: 25,
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<SelectionCubit, UserSelection>(
                buildWhen: (p, n) => p.activeTabId != n.activeTabId,
                builder: (_, selection) => BlocBuilder<TabCubit, TabList>(
                  builder: (ctx, state) => buildByState(ctx, state, selection),
                ),
              ),
            ),
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {
            //     BlocProvider.of<TabCubit>(context).addUntitled();
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 8.0),
            //     child: Icon(Icons.add, size: 18, color: Color(0xffBFC5C8)),
            //   ),
            // ),
          ],
        ));
  }

  void activeTab(BuildContext context, TabBean tab) {
    BlocProvider.of<SelectionCubit>(context).selectTab(tab.id);
    ExampleState state = BlocProvider.of<ExampleBloc>(context).state;
    MatchBloc matchBloc = BlocProvider.of<MatchBloc>(context);
    if (state is FullExampleState) {
      RegExample example =
          state.data.firstWhere((element) => element.id == tab.id);
      matchBloc.add(
          MatchRegex(content: example.content, regex: example.recommend.first));
    }
  }

  Widget buildByState(
      BuildContext context, TabList state, UserSelection selection) {
    final int activeTabId = selection.activeTabId;
    return ListView(
        scrollDirection: Axis.horizontal,
        children: state.tabs.asMap().keys.map((int index) {
          TabBean tab = state.tabs[index];
          bool active = activeTabId == tab.id;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => activeTab(context, tab),
            child: Container(
              height: 25,
              color: active ? Colors.white : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_copy_outlined,
                        size: 13, color: Color(0xffBFC5C8)),
                    const SizedBox(width: 2),
                    Text(tab.name,
                        style: const TextStyle(height: 1, fontSize: 12)),
                    const SizedBox(width: 5),
                    GestureDetector(
                        onTap: () =>
                            deleteTab(context, tab, selection, index, state),
                        child: const Icon(Icons.close,
                            size: 13, color: Color(0xffBFC5C8))),
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }

  void deleteTab(
    BuildContext context,
    TabBean tab,
    UserSelection selection,
    int index,
    TabList state,
  ) {
    if (tab.id == selection.activeTabId) {
      if (state.tabs.length != 1) {
        int i = index == 0 ? 1 : index - 1;
        activeTab(context, state.tabs[i]);
      } else {
        BlocProvider.of<SelectionCubit>(context).selectTab(0);
      }
    }
    BlocProvider.of<TabCubit>(context).deleteById(tab.id);
  }
}
