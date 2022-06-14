
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/content/bloc/bloc.dart';
import 'package:regexpo/src/content/bloc/state.dart';

class FootBar extends StatelessWidget {
  const FootBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: const Color(0xffF2F2F2),
      child: Row(
        children: const[
          Spacer(),
          ResultShower(),
          SizedBox(width: 20,)
        ],
      ),
    );
  }
}


class ResultShower extends StatelessWidget {
  const ResultShower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc,MatchState>(builder: buildInfoByState);
  }

  Widget buildInfoByState(BuildContext context, MatchState state) {
    if(state is MatchError){
      return Text('${state.error}',style: TextStyle(fontSize: 11,color: Colors.red),);
    }

    if(state is MatchSuccess){
      return Wrap(
        spacing: 6,
        children: [
          Text('规则正常',style: TextStyle(fontSize: 11,color: Colors.blue),),
          Text('match: ${state.matchCount}',style: TextStyle(fontSize: 11,color: Colors.blue),),
          Text('group: ${state.groupCount}',style: TextStyle(fontSize: 11,color: Colors.blue),),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
