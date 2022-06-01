import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/components/single_filter.dart';
import 'package:regexpo/src/directory/bloc/bloc.dart';
import 'package:regexpo/src/directory/bloc/state.dart';

import '../../directory/models/reg_example.dart';
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
              Text('推荐正则',style: TextStyle(fontSize: 11),),
              Spacer(),
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(child: BlocBuilder<ExampleBloc,ExampleState>(builder: _buildByState)),
      ],
    );
  }

  Widget _buildByState(BuildContext context, ExampleState state) {
    if (state is FullExampleState) {
      return BlocBuilder<SelectionCubit, UserSelection>(
        buildWhen: (p, n) {
          return p.recommendIndex != n.recommendIndex
          ||p.activeTabId!=n.activeTabId
          ||p.activeExampleId!=n.activeExampleId;
        },
        builder: (_, s) {
          int id = s.activeTabId;
          RegExample example =
              state.data.firstWhere((element) => element.id == id);
          return SingleFilter<String>(
            data: example.recommend,
            onItemClick: (index) =>
                _doSelectStart(context, index, example.recommend),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  void _doSelectStart(BuildContext context, int index, List<String> recommend) {
    String regex = recommend[index];
    BlocProvider.of<SelectionCubit>(context).updateRecommendIndex(index);
    BlocProvider.of<SelectionCubit>(context).updateRegex(regex);
  }
}
