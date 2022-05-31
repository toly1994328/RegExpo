import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                BlocProvider.of<TabCubit>(context).addUntitled();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.add, size: 18, color: Color(0xffBFC5C8)),
              ),
            ),
          ],
        ));
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
            onTap: () {
              BlocProvider.of<SelectionCubit>(context).selectTab(tab.id);
            },
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
                        style: TextStyle(
                            height: 1,
                            fontSize: 12,
                            color: tab.flag
                                ? const Color(0xff007800)
                                : Colors.black)),
                    const SizedBox(width: 5),
                    GestureDetector(
                        onTap: () =>
                            onDelete(context, tab, selection, index, state),
                        child: const Icon(Icons.close,
                            size: 13, color: Color(0xffBFC5C8))),
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }

  void onDelete(BuildContext context, TabBean tab, UserSelection selection,
      int index, TabList state) {
    if (tab.id == selection.activeTabId) {
      if (state.tabs.length != 1) {
        int i = index == 0 ? 1 : index - 1;
        BlocProvider.of<SelectionCubit>(context).selectTab(state.tabs[i].id);
      } else {
        BlocProvider.of<SelectionCubit>(context).selectTab(0);
      }
    }

    BlocProvider.of<TabCubit>(context).deleteById(tab.id);
  }
}
