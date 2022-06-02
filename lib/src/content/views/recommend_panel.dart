import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/components/single_filter.dart';
import 'package:regexpo/src/directory/bloc/bloc.dart';
import 'package:regexpo/src/directory/bloc/state.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';

import '../../navigation/bloc/bloc_exp.dart';

class RecommendPanel extends StatelessWidget {
  const RecommendPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          padding: const EdgeInsets.only(left: 8,right: 4),
          alignment: Alignment.centerLeft,
          color: const Color(0xffF3F3F3),
          child: Row(
            children: const [
              Text(
                '推荐正则',
                style: TextStyle(fontSize: 11),
              ),
              Spacer(),
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(
            child: BlocConsumer<SelectionCubit, UserSelection>(
          listener: _listenTabChange,
          listenWhen: (p,n)=>p.activeTabId!=n.activeTabId,
          builder: _buildByState,
          buildWhen: (p, n) =>
              p.recommendIndex != n.recommendIndex ||
              p.activeTabId != n.activeTabId ||
              p.activeExampleId != n.activeExampleId,
        )),
      ],
    );
  }

  Widget _buildByState(BuildContext context, UserSelection state) {
    int tabId = state.activeTabId;
    ExampleState exampleState = BlocProvider.of<ExampleBloc>(context).state;
    if (exampleState is FullExampleState && tabId > 0) {
      RegExample example = exampleState.data.firstWhere((e) => e.id == tabId);
      return SingleFilter<String>(
        data: example.recommend,
        onItemClick: (index) => _doSelectItem(context, index, example.recommend),
      );
    }
    return const SizedBox.shrink();
  }

  void _doSelectItem(BuildContext context, int index, List<String> recommend) {
    String regex = recommend[index];
    BlocProvider.of<SelectionCubit>(context).updateRecommendIndex(index);
    BlocProvider.of<SelectionCubit>(context).updateRegex(regex);
  }

  void _listenTabChange(BuildContext context, UserSelection state) {
    int tabId = state.activeTabId;
    ExampleState exampleState = BlocProvider.of<ExampleBloc>(context).state;
    if (exampleState is FullExampleState&&tabId>0) {
      RegExample example = exampleState.data.firstWhere((e) => e.id == tabId);
      BlocProvider.of<SelectionCubit>(context).updateRecommendIndex(0);
      BlocProvider.of<SelectionCubit>(context).updateRegex(example.recommend.first);
    }
  }
}
