import 'package:flutter/material.dart';
import 'package:regexpo/src/views/desk_ui/home/content_text_panel.dart';
import 'package:regexpo/src/views/desk_ui/home/home_foot.dart';
import 'package:regexpo/src/views/desk_ui/home/tool_panel.dart';
import 'package:regexpo/src/views/phone_ui/record/record_drawer.dart';
import 'package:regexpo/src/views/phone_ui/record/record_page.dart';
import 'package:regexpo/src/views/phone_ui/user/user_page.dart';
import 'package:regexpo/src/views/phone_ui/home/clickable_content_panel.dart';
import 'package:regexpo/src/views/phone_ui/user/regex_concept_list.dart';
import 'package:regexpo/src/views/phone_ui/user/common_regex_list.dart';

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

class RegexNotePage extends StatefulWidget {
  const RegexNotePage({super.key});

  @override
  State<RegexNotePage> createState() => _RegexNotePageState();
}

class _RegexNotePageState extends State<RegexNotePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text("正则手记", style: TextStyle(color: titleColor, fontSize: 16)),
        elevation: 0,
        bottom: TabBar(
          dividerHeight: 0,
          controller: _tabController,
          tabs: const [
            Tab(text: '正则概念'),
            Tab(text: '符号一览'),
            Tab(text: '常用正则'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RegexConceptList(),
          RegexNoteList(fontSize: 16),
          CommonRegexList(),
        ],
      ),
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
          const Expanded(child: ClickableContentPanel()),
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
