import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/navigation/bloc/bloc_exp.dart';

import 'rrect_check.dart';

/// create by 张风捷特烈 on 2020-04-07
/// contact me by email 1981462002@qq.com
/// 说明:

typedef BoolWidgetBuilder = Widget Function(
    BuildContext context, int index, bool selected);

class SingleFilter<T> extends StatefulWidget {
  final List<T> data;

  final void Function(int index) onItemClick;

   const SingleFilter({Key? key,
    required this.data,
    required this.onItemClick,
  }) : super(key: key);

  @override
  _SingleFilterState createState() => _SingleFilterState();
}

class _SingleFilterState<T> extends State<SingleFilter<T>> {
  final List<int> _selected = <int>[];



  @override
  void didUpdateWidget(covariant SingleFilter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selected.clear();
    _selected.add(0);
  }

  @override
  void initState() {
    super.initState();
    _selected.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemExtent: 28,
      children: widget.data.asMap().keys.map((int index) {
        int recommendIndex = BlocProvider.of<SelectionCubit>(context).state.recommendIndex;
        bool selected = index == recommendIndex;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: ()=> widget.onItemClick.call(index),
          child: Row(
            children: [
              RRectCheck(
                inActiveColor: Color(0xffB0B0B0),
                active: selected,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(child: Text(widget.data[index].toString()))
            ],
          ),
        );
      }).toList(),
    );
  }
}
