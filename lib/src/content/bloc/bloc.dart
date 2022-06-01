import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/match_result.dart';
import '../model/regexp_config.dart';
import 'state.dart';
import 'event.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {

  MatchBloc():super( const MatchSuccess(results: [])){
    on<MatchRegex>(_onMatchRegex);
  }

  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  final List<String> sList = ['\t', '\v', '\n', '\r', '\f'];

  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  void _onMatchRegex(MatchRegex event, Emitter<MatchState> emit) async{
    String pattern = event.regex;
    String src = event.content;
    RegExpConfig config = event.config;
    MatchInfo? selectMatch ;
    if (pattern.isEmpty||src.isEmpty) {
      emit(MatchSuccess(results: const [], span: TextSpan(text: src)));
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
      emit(MatchSuccess(results: const [], span: TextSpan(text: src)));
    }

    List<TextSpan> span = [];
    int startTime = DateTime.now().millisecondsSinceEpoch;
    List<RegExpMatch> allMatches = regExp.allMatches(src).toList();
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int matchTime = endTime-startTime;
    if (allMatches.isEmpty) {
      emit(MatchSuccess(results: const [], span: TextSpan(text: src)));
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
      int? selectedMatch = selectMatch?.matchIndex;

      late TextStyle textStyle;
      TextStyle lightBgStyle = lightTextStyle.copyWith(
          color: colors[i % colors.length], backgroundColor: Colors.cyanAccent);

      TextStyle colorStyle =
      lightTextStyle.copyWith(color: colors[i % colors.length]);

      if (selectMatch!= null) {
        //选择的不是组
        if (!selectMatch.isGroup) {
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
          String groupContent = selectMatch.content ?? '';
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
      matchInfos.addAll(_collectMatchInfo(match, i));
    }

    emit(MatchSuccess(results: matchInfos, span: TextSpan(children: span)));
  }

  List<MatchInfo> _collectMatchInfo(RegExpMatch match, int index) {
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
