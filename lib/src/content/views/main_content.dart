import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/content/model/match_result.dart';

import '../../navigation/bloc/selection_cubic.dart';
import '../../navigation/bloc/tab_cubic.dart';
import '../../navigation/model/selection.dart';
import '../../navigation/model/tab_bean.dart';

class MainContent extends StatefulWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: BlocBuilder<SelectionCubit, UserSelection>(
          buildWhen: (p,n)=>p.activeTabId!=n.activeTabId,
          builder: (_, selection) => BlocBuilder<TabCubit, TabList>(
              builder: (ctx, state) => buildByState(ctx, state, selection))),
    );
  }

  Widget buildByState(BuildContext ctx, TabList state, UserSelection selection) {
    if(state.tabs.isEmpty) return Text('暂无内容');
    // return LocalTerminal();
    String content = state.tabs.firstWhere((element) => element.id==selection.activeTabId).content;
    return ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text.rich(formSpan(content, r'《.*?》')),
          ),
        ),
      ] ,
    );
  }

  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  final List<String> sList = ['\t', '\v', '\n', '\r', '\f'];

  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  // InlineSpan formSpan(String src, String pattern) {
  //   List<TextSpan> span = [];
  //   List<String> parts = src.split(pattern);
  //   if (parts.length > 1) {
  //     for (int i = 0; i < parts.length; i++) {
  //       span.add(TextSpan(text: parts[i]));
  //       if (i != parts.length - 1) {
  //         span.add(TextSpan(text: pattern, style: lightTextStyle));
  //       }
  //     }
  //   } else {
  //     span.add(TextSpan(text: src));
  //   }
  //   return TextSpan(children: span);
  // }
  // InlineSpan formSpan(String src, String pattern) {
  //   List<TextSpan> span = [];
  //   RegExp regExp = RegExp(pattern); // tag1: 创建正则对象
  //   List<String> parts = src.split(regExp);
  //   // tag2: 获取匹配结果
  //   List<RegExpMatch> allMatches = regExp.allMatches(src).toList();
  //   if (parts.length > 1) {
  //     for (int i = 0; i < parts.length; i++) {
  //       span.add(TextSpan(text: parts[i]));
  //       if (i != parts.length - 1) {
  //         // tag3: 根据匹配结果，拿到匹配的字符串
  //         span.add(TextSpan(text: allMatches[i].group(0), style: lightTextStyle));
  //       }
  //     }
  //   } else {
  //     span.add(TextSpan(text: src));
  //   }
  //   return TextSpan(children: span);
  // }

  ValueNotifier<MatchResult> matchResult = ValueNotifier(MatchResult());
  ValueNotifier<MatchInfo?> selectMatchInfo = ValueNotifier(null);
  // ValueNotifier<RegExpConfig> regExpConfig = ValueNotifier(RegExpConfig());
  final TextEditingController regTextCtrl = TextEditingController();
  // late ValueNotifier<RegTestItem> selectSideItem =
  // ValueNotifier(RegTestItem.test);

  InlineSpan formSpan(String src, String pattern) {
    if (pattern.isEmpty) {
      // matchResult.value = MatchResult();
      return TextSpan(text: src);
    }
    List<TextSpan> span = [];
    late RegExp regExp;
    try {
      regExp = RegExp(
        pattern,
        // multiLine: regExpConfig.value.multiLine,
        // dotAll: regExpConfig.value.dotAll,
        // unicode: regExpConfig.value.unicode,
        // caseSensitive: regExpConfig.value.caseSensitive,
      );
    } catch (e) {
      // matchResult.value = MatchResult(error: true);
      return TextSpan(text: src);
    }
    int startTime = DateTime.now().millisecondsSinceEpoch;
    List<RegExpMatch> allMatches = regExp.allMatches(src).toList();
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print(endTime-startTime);

    if (allMatches.isEmpty) {
      // matchResult.value = MatchResult();
      return TextSpan(text: src);
    }

    int start = 0;
    int end = 0;
    List<MatchInfo> matchInfos = [];

    for (int i = 0; i < allMatches.length; i++) {
      RegExpMatch match = allMatches[i];
      RegExpMatch? prevMatch;
      if (i > 0) {
        prevMatch = allMatches[i - 1];
      }
      start = prevMatch?.end ?? 0;
      end = match.start;
      String noMatchStr = match.input.substring(start, end);
      span.add(TextSpan(text: noMatchStr));

      start = match.start;
      end = match.end;
      String matchStr = match.input.substring(start, end);
      if (matchStr.isEmpty || sList.contains(matchStr)) {
        span.add(TextSpan(
          text: ' ',
          style: lightTextStyle.copyWith(
              backgroundColor: colors[i % colors.length].withOpacity(0.5)),
        ));
      }
      int? selectedMatch = selectMatchInfo.value?.matchIndex;

      late TextStyle textStyle;
      TextStyle lightBgStyle = lightTextStyle.copyWith(
          color: colors[i % colors.length], backgroundColor: Colors.cyanAccent);

      TextStyle colorStyle =
      lightTextStyle.copyWith(color: colors[i % colors.length]);

      if (selectMatchInfo.value != null) {
        //选择的不是组
        if (!selectMatchInfo.value!.isGroup) {
          if (i == selectedMatch) {
            textStyle = lightBgStyle;
          } else {
            textStyle = colorStyle;
          }
          span.add(TextSpan(
            text: matchStr.replaceAll(" ", '␣'),
            style: textStyle,
          ));
        } else {
          // 匹配的是组
          String groupContent = selectMatchInfo.value!.content ?? '';
          List<String> leftStr = matchStr.split(groupContent);
          if (leftStr.length == 2 && selectedMatch == i) {
            span.add(TextSpan(
              text: leftStr[0].replaceAll(" ", '␣'),
              style: colorStyle,
            ));

            span.add(TextSpan(
              text: groupContent.replaceAll(" ", '␣'),
              style: lightBgStyle,
            ));

            span.add(TextSpan(
              text: leftStr[1].replaceAll(" ", '␣'),
              style: colorStyle,
            ));
          } else {
            span.add(TextSpan(
              text: matchStr.replaceAll(" ", '␣'),
              style: colorStyle,
            ));
          }
        }
      } else {
        span.add(TextSpan(
          text: matchStr.replaceAll(" ", '␣'),
          style: colorStyle,
        ));
      }

      if (i == allMatches.length - 1) {
        String tail = match.input.substring(allMatches.last.end);
        span.add(TextSpan(text: tail));
      }
      matchInfos.addAll(collectMatchInfo(match, i));
    }

    // matchResult.value = MatchResult(results: matchInfos);
    return TextSpan(children: span);
  }

  List<MatchInfo> collectMatchInfo(RegExpMatch match, int index) {
    List<MatchInfo> result = [];
    String fullContent = match.group(0) ?? '';
    result.add(MatchInfo(
        content: fullContent,
        groupNum: 0,
        startPos: match.start,
        endPos: match.end,
        matchIndex: index,
        end: match.groupCount == 0));

    for (int j = 1; j <= match.groupCount; j++) {
      String? content = match.group(j);
      if (content != null) {
        int start = fullContent.indexOf(content);
        result.add(MatchInfo(
            content: content,
            groupNum: j,
            startPos: match.start + start,
            endPos: match.start + content.length,
            matchIndex: index,
            end: j == match.groupCount));
      } else {
        result.add(MatchInfo(
            content: content,
            groupNum: j,
            startPos: -1,
            endPos: -1,
            matchIndex: index,
            end: j == match.groupCount));
      }
    }
    return result;
  }
}
