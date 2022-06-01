import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/components/check_circle.dart';
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
          padding: EdgeInsets.only(left: 8,right: 4),
          alignment: Alignment.centerLeft,
          color: Color(0xffF3F3F3),
          child: Row(
            children: [
              Text('推荐正则',style: TextStyle(fontSize: 11),),
              Spacer(),
              // Icon(Icons.add,size: 16,color: Color(0xff7E7E7E),)
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(child: BlocBuilder<ExampleBloc,ExampleState>(builder: _buildByState)),
      ],
    );
    // return Container();
  }

  Widget _buildByState(BuildContext context, ExampleState state) {
    if(state is FullExampleState){
      int id = BlocProvider.of<SelectionCubit>(context).state.activeTabId;
      RegExample example = state.data.firstWhere((element) => element.id==id);
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        itemExtent: 28,
        children: example.recommend.map((e) => Row(
          children: [
            RRectCheck(
                inActiveColor: Color(0xffB0B0B0),
                value: true, onChanged: (v){}),
            const SizedBox(width: 8,),
            Flexible(child: Text(e))
          ],
        )).toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
