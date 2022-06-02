import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/content/bloc/event.dart';
import 'package:regexpo/src/directory/bloc/bloc.dart';
import 'package:regexpo/src/directory/bloc/state.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';
import 'package:regexpo/src/navigation/bloc/bloc_exp.dart';

import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../model/match_result.dart';

class MatchPanel extends StatelessWidget{
  const MatchPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          padding: const EdgeInsets.only(left: 8, right: 4),
          alignment: Alignment.centerLeft,
          color: const Color(0xffF3F3F3),
          child: Row(
            children: const [
              Text(
                '匹配组信息',
                style: TextStyle(fontSize: 11),
              ),
              Spacer(),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<MatchBloc, MatchState>(
            // buildWhen: (p,n)=>p.runtimeType!=n.runtimeType,
            builder: (_, s) {
              if (s is MatchSuccess) {
                return MatchListView(
                  s.results,
                  onSelectItem: (MatchInfo? info) {
                    print(info);
                    selectMatchInfo(context,info);
                  },
                );
              }
              return Text('匹配异常');
            },
          ),
        ),
      ],
    );
  }

  void selectMatchInfo(BuildContext context,MatchInfo? info){
    int tabId = BlocProvider.of<SelectionCubit>(context)
        .state
        .activeTabId;
    String regex =
        BlocProvider.of<SelectionCubit>(context).state.regex;
    ExampleState exampleState =
        BlocProvider.of<ExampleBloc>(context).state;
    MatchBloc matchBloc = BlocProvider.of<MatchBloc>(context);
    if (exampleState is FullExampleState) {
      RegExample example = exampleState.data
          .firstWhere((element) => element.id == tabId);
      matchBloc.add(MatchRegex(
          content: example.content,
          regex: regex,
          selectMatch: info));
    }
  }
}

class MatchListView extends StatefulWidget {
  final List<MatchInfo> matchResult;
  final ValueChanged<MatchInfo?>? onSelectItem;

  const MatchListView(this.matchResult, {Key? key, this.onSelectItem})
      : super(key: key);

  @override
  _MatchPanelMatchPanelListState createState() =>
      _MatchPanelMatchPanelListState();
}

class _MatchPanelMatchPanelListState extends State<MatchListView> {
  List<String> data = [];
  final ScrollController _ctrl = ScrollController();
  int _selectIndex = 0;

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          controller: _ctrl,
          separatorBuilder: (_, index) =>
              _buildSeparator(index, widget.matchResult),
          itemBuilder: (context, index) =>
              _buildGroupItem(context, index, widget.matchResult),
          itemCount: widget.matchResult.length,
        ))
      ],
    );
  }

  Widget _buildGroupItem(
      BuildContext context, int index, List<MatchInfo> results) {
    MatchInfo matchInfo = results[index];
    int groupNum = matchInfo.groupNum;
    String name = groupNum == 0
        ? "Match  ${matchInfo.matchIndex + 1}"
        : "Group  $groupNum";
    Color color = colors[matchInfo.matchIndex % colors.length];

    Gradient? gradient;
    if (matchInfo.enable) {
      gradient = _selectIndex == index
          ? LinearGradient(
              colors: [
                color.withOpacity(0),
                color.withOpacity(0.1),
                color.withOpacity(0.2)
              ],
            )
          : null;
    } else {
      gradient = LinearGradient(
        colors: [
          Colors.grey.withOpacity(0),
          Colors.grey.withOpacity(0.1),
          Colors.grey.withOpacity(0.2)
        ],
      );
    }

    return InkWell(
      onHover: (active) => _highLightItem(matchInfo, index,active),
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 8 : 0),
        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
            gradient: gradient,
            border: Border(left: BorderSide(width: 2, color: color))),
        child: Wrap(
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (matchInfo.enable)
                  Text(
                    '位置:${matchInfo.startPos}-${matchInfo.endPos}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "匹配结果: ${matchInfo.content ?? "无匹配"}",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _highLightItem(MatchInfo matchInfo, int index,bool active) {
    print(active);
    if(!active){
      widget.onSelectItem?.call(null);
      setState(() {
        _selectIndex = -1;
      });
      return;
    }
    if (!matchInfo.enable&&!active) return;
    setState(() {
      _selectIndex = index;
    });
    widget.onSelectItem?.call(matchInfo);
  }

  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  Widget _buildSeparator(int index, List<MatchInfo> results) {
    MatchInfo info = results[index];
    Color color = colors[results[index].matchIndex % colors.length];
    if (info.end) {
      return const Divider();
    } else {
      return Container(
          decoration: BoxDecoration(
              border: Border(left: BorderSide(width: 2, color: color))),
          child: const Divider(
            color: Colors.transparent,
            height: 4,
          ));
    }
  }
}
