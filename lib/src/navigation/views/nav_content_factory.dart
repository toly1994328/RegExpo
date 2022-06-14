import 'package:flutter/material.dart';
import 'package:regexpo/src/content/views/match_panel.dart';
import 'package:regexpo/src/content/views/recommend_panel.dart';
import 'package:regexpo/src/directory/views/example_panel.dart';
import 'package:regexpo/src/directory/views/input_panel.dart';
import 'package:regexpo/src/tool/tool_panel.dart';

class NavContentFactory{

  static Widget getContentById(int id){
    switch(id){
      case 0: return const SizedBox.shrink();
      case 1: return const ExamplePanel();
      case 2: return const MatchPanel();
      case 4: return const InputPanel();
      case 5: return const ToolPanel();
      case 7: return const RecommendPanel();
    }
    return Text('$id');
  }

}