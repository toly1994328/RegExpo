import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/views/desk_ui/home/content_text_panel.dart';
import 'package:regexpo/src/views/desk_ui/home/home_foot.dart';
import 'package:regexpo/src/views/desk_ui/home/tool_panel.dart';
import 'package:regexpo/src/views/phone_ui/record/record_page.dart';
import 'package:regexpo/src/views/phone_ui/user/user_page.dart';
import '../link_regex/link_regex_tab.dart';
import '../record/record_panel.dart';
import 'home_pop_icon.dart';
import 'phone_regex_input.dart';
import 'pure_bottom_bar.dart';

class PhoneHomePage extends StatefulWidget {
  const PhoneHomePage({super.key});

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {

  final PageController _pageCtrl = PageController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:  PureBottomBar(
        onItemTap: _onItemTap,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageCtrl,
        children: const [
          HomeContent(),
          RecordPage(),
          RegexNotePage(),
          UserPage(),
        ],
      ),
    );
  }

  void _onItemTap(int value) {
    if(value!=_pageCtrl.page){
      _pageCtrl.jumpToPage(value);
    }
  }
}

class RegexNotePage extends StatelessWidget {
  const RegexNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text("正则语法速查",style: TextStyle(color: titleColor,fontSize: 16),),
        elevation: 0,
      ),
      body: const RegexNoteList(fontSize: 14,),
    );
  }
}


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PhoneHomeTopBar(),
      drawer: const RecordDrawer(),
      body: Column(
        children: [
          const Expanded(child: ContentTextPanel()),
          Container(
            height: 24,
            alignment: Alignment.center,
            color: color,
            child: const RegexConfigTools(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}


class PhoneHomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PhoneHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;

    return AppBar(
      bottom: const LinkRegexTab(),
      titleSpacing: 0,
      backgroundColor: color,
      elevation: 0,
      title: const PhoneRegexInput(),
      actions: [
        HomePopIcon(
          onFileSelect: (f) => _onFileSelect(context, f),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight + 26);
  }

  void _onFileSelect(BuildContext context, File file) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.openFile(file);
  }
}



