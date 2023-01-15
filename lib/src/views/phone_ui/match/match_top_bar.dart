import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/desk_ui/home/home_foot.dart';

class PhoneMatchTopBar extends StatelessWidget {
  const PhoneMatchTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;


    TextStyle title = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 8, right: 8),
      alignment: Alignment.centerLeft,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
              Text(
                '匹配组信息',
                style: title,
              ),
              // Spacer(),
            ],
          ),
          ResultShower()
        ],
      ),
    );
  }
}

class _ResultInfo extends StatelessWidget {
  const _ResultInfo({Key? key}) : super(key: key);

  final TextStyle errorStyle = const TextStyle(fontSize: 11, color: Colors.red,height: 1);
  final TextStyle style = const TextStyle(fontSize: 11, color: Colors.blue,height: 1);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
        builder: buildInfoByState);
  }

  Widget buildInfoByState(BuildContext context, MatchState state) {
    if (state is MatchError) {
      return Text(
        state.error,
        style: errorStyle,
      );
    }
    if (state is MatchSuccess) {
      return Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '规则正常',
            style: style,
          ),
          Text(
            'match: ${state.matchCount}',
            style: style,
          ),
          Text(
            'group: ${state.groupCount}',
            style: style,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

