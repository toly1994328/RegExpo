import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/models/models.dart';

import 'match_content.dart';

class MatchPanel extends StatelessWidget {
  const MatchPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    bool mobile = Platform.isIOS || Platform.isAndroid;
    TextStyle title = mobile
        ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 11);
    return Column(
      children: [
        Container(
          height: mobile ? 36 : 25,
          padding: const EdgeInsets.only(left: 8, right: 4),
          alignment: Alignment.centerLeft,
          color: color,
          child: Row(
            mainAxisAlignment:
                mobile ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                '匹配组信息',
                style: title,
              ),
              // Spacer(),
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(child: MatchContent()),
      ],
    );
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
  int _selectIndex = -1;

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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    bool mobile = Platform.isIOS || Platform.isAndroid;

    void reset([dynamic v]) {
      if (!mobile) return;
      setState(() {
        _selectIndex = -1;
      });
      widget.onSelectItem?.call(null);
    }

    return InkWell(
      onHover: (active) => _highLightItem(matchInfo, index, active),
      onTapDown: !matchInfo.enable
          ? null : (_) {
              if (!mobile) return;
              _highLightItem(matchInfo, index, true);
            },
      onTapUp: !matchInfo.enable ? null : reset,
      onTapCancel: !matchInfo.enable ? null : reset,
      onTap: !matchInfo.enable ? null : () {},
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : 0),
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
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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

  void _highLightItem(MatchInfo matchInfo, int index, bool active) {
    if (!active) {
      widget.onSelectItem?.call(null);
      setState(() {
        _selectIndex = -1;
      });
      return;
    }
    if (!matchInfo.enable && !active) return;
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
