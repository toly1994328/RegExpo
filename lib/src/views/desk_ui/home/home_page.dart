import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/cons.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/components/components.dart';

import '../record/record_cache_bar.dart';
import 'content_text_panel.dart';
import 'home_foot.dart';
import 'home_top_bar.dart';
import 'left_nav_content.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'right_nav_content.dart';
import 'package:path/path.dart' as path;
class DeskHomePage extends StatefulWidget {
  const DeskHomePage({super.key});

  @override
  State<DeskHomePage> createState() => _DeskHomePageState();
}

class _DeskHomePageState extends State<DeskHomePage> {
  final PageController _leftCtrl = PageController();
  final PageController _rightCtrl = PageController();

  //导航数据 - 激活 id
  int activeLeftNavId = 1;
  int activeRightNavId = 4;

  List<NavTab> get leftTabs =>
      Cons.navTabs.where((e) => e.type == NavType.left).toList();

  List<NavTab> get rightTabs =>
      Cons.navTabs.where((e) => e.type == NavType.right).toList();

  @override
  void dispose() {
    _leftCtrl.dispose();
    _rightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeTopBar(
            onRegexChange: _onRegexChange,
            onFileSelect: _onFileSelect,
          ),
          Gap.dividerH,
          Expanded(
            child: Row(
              children: [
                RailTabNavigation(
                  width: 22,
                  activeId: activeLeftNavId,
                  onSelect: _onSelectNav,
                  items: leftTabs,
                ),
                LeftNavContent(
                  controller: _leftCtrl,
                  activeIndex: activeLeftNavId,
                ),
                 Expanded(
                  child: Column(
                    children: const [
                      RecordCacheBar(),
                      Expanded(child: ContentTextPanel()),
                    ],
                  ),
                ),
                RightNavContent(
                  controller: _rightCtrl,
                  activeIndex: activeRightNavId,
                ),
                RailTabNavigation(
                  width: 22,
                  textDirection: TextDirection.rtl,
                  activeId: activeRightNavId,
                  onSelect: _onSelectNav,
                  items: rightTabs,
                ),
              ],
            ),
          ),
          Gap.dividerH,
          const FootBar(),
        ],
      ),
    );
  }

  void _onSelectNav(NavTab nav) {
    if (nav.type == NavType.right) {
      if (activeRightNavId == nav.id) {
        activeRightNavId = 0;
      } else {
        activeRightNavId = nav.id;
        int index = rightTabs.indexOf(nav);
        _rightCtrl.jumpToPage(index);
      }
    } else {
      if (activeLeftNavId == nav.id) {
        activeLeftNavId = 0;
      } else {
        activeLeftNavId = nav.id;
        int index = leftTabs.indexOf(nav);
        _leftCtrl.jumpToPage(index);
      }
    }
    setState(() {});
  }

  void _onFileSelect(File file) async{
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.openFile(file);
  }

  void _onRegexChange(String value) {
    context.read<MatchBloc>().add(ChangeRegex(pattern: value));
  }
}
