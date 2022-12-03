import 'package:flutter/material.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';


const kRenderColors = [Colors.red, Colors.green, Colors.blue];
const Map<String, String> ksListMap = {
  '\t': 't',
  '\v': 'v',
  '\n': 'n',
  '\r': 'r',
  '\f': 'f',
};

class RegexParser {
  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  MatchState match(
    String content,
    String pattern,
    RegExpConfig config, {
    MatchInfo? activeMatch,
  }) {
    if (pattern.isEmpty || content.isEmpty) {
      return MatchSuccess(
        results: const [],
        content: content,
        pattern: pattern,
        config: config,
        span: TextSpan(text: content),
      );
    }

    // 生成正则表达式
    late RegExp regExp;
    try {
      regExp = RegExp(
        pattern,
        multiLine: config.multiLine,
        dotAll: config.dotAll,
        unicode: config.unicode,
        caseSensitive: config.caseSensitive,
      );
    } catch (e) {
      return MatchError(
        error: '规则错误 无效正则',
        content: content,
        pattern: pattern,
        config: config,
      );
    }

    List<TextSpan> span = [];
    List<MatchInfo> matchResults = [];

    int startTime = DateTime.now().millisecondsSinceEpoch;

    int index = 0;
    content.splitMapJoin(regExp, onMatch: (Match match) {
      String value = match.group(0) ?? '';
      span.add(_handleHeightStyle(value, index, active: activeMatch));
      matchResults.addAll(_collectMatchInfo(match, index));
      index++;
      return '';
    }, onNonMatch: (str) {
      span.add(TextSpan(text: str));
      return '';
    });

    int endTime = DateTime.now().microsecondsSinceEpoch;
    int matchTime = endTime - startTime;

    return MatchSuccess(
      results: matchResults,
      span: TextSpan(children: span),
      content: content,
      pattern: pattern,
      config: config,
      matchTime: matchTime,
    );
  }

  List<MatchInfo> _collectMatchInfo(Match match, int index) {
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

  // 处理高亮文本样式
  TextSpan _handleHeightStyle(String value, index, {MatchInfo? active}) {
    Color color = kRenderColors[index % kRenderColors.length];
    TextStyle style = lightTextStyle.copyWith(color: color);
    TextSpan? hoverSpan = _handleHoverHeightStyle(value, index, active: active);
    if (hoverSpan != null) return hoverSpan;
    if (value.isEmpty) {
      TextStyle emptyStyle =
          style.copyWith(backgroundColor: color.withOpacity(0.6));
      return TextSpan(text: '_', style: emptyStyle);
      // span.add(WidgetSpan(
      //     alignment: PlaceholderAlignment.middle,
      //     child: FlutterLogo(size: 12,)));
    } else if (ksListMap.keys.contains(value)) {
      TextStyle emptyStyle = style.copyWith(
        color: Colors.white,
        backgroundColor: color.withOpacity(0.6),
      );
      return TextSpan(
        text: ksListMap[value]! + value,
        style: emptyStyle,
      );
    } else if (value.contains(" ")) {
      return TextSpan(text: value.replaceAll(" ", '␣'), style: style);
    } else {
      return TextSpan(text: value, style: style);
    }
  }

  TextSpan? _handleHoverHeightStyle(
    String value,
    int index, {
    MatchInfo? active,
  }) {
    Color color = kRenderColors[index % kRenderColors.length];
    Color bgColor = Colors.orange.withOpacity(0.2);
    TextStyle style = lightTextStyle.copyWith(color: color);
    TextStyle bgStyle = style.copyWith(backgroundColor: bgColor);
    if (active != null) {
      if (!active.isGroup) {
        if (active.matchIndex == index) {
          style = bgStyle;
        }
        return TextSpan(text: value, style: style);
      } else {
        String groupContent = active.content ?? '';
        List<String> leftStr = value.split(groupContent);
        if (leftStr.length == 2 && active.matchIndex == index) {
          return TextSpan(children: [
            TextSpan(text: leftStr[0], style: style),
            TextSpan(text: groupContent, style: bgStyle),
            TextSpan(text: leftStr[1], style: style),
          ]);
        } else {
          return TextSpan(text: value, style: style);
        }
      }
    }
    return null;
  }
}
