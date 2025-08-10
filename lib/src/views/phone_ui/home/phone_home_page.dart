import 'package:flutter/material.dart';
import 'package:regexpo/src/views/desk_ui/home/content_text_panel.dart';
import 'package:regexpo/src/views/desk_ui/home/home_foot.dart';
import 'package:regexpo/src/views/desk_ui/home/tool_panel.dart';
import 'package:regexpo/src/views/phone_ui/record/record_drawer.dart';
import 'package:regexpo/src/views/phone_ui/record/record_page.dart';
import 'package:regexpo/src/views/phone_ui/user/user_page.dart';

import 'bottom_bar.dart';
import 'home_top_bar.dart';

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
      bottomNavigationBar: HomeBottomBar(onTap: _onItemTap),
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
    if (value != _pageCtrl.page) {
      _pageCtrl.jumpToPage(value);
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }
}

class RegexNotePage extends StatelessWidget {
  const RegexNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
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
    Color color = Theme.of(context).colorScheme.surface;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PhoneHomeTopBar(),
      drawer: const RecordDrawer(),
      body: Column(
        children: [
          const Expanded(child: ContentTextPanel(),),
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




