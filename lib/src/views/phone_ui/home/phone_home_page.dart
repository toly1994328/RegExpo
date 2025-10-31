import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/views/desk_ui/home/content_text_panel.dart';
import 'package:regexpo/src/views/desk_ui/home/home_foot.dart';
import 'package:regexpo/src/views/desk_ui/home/tool_panel.dart';
import 'package:regexpo/src/views/phone_ui/record/record_drawer.dart';
import 'package:regexpo/src/views/phone_ui/record/record_page.dart';
import 'package:regexpo/src/views/phone_ui/user/user_page.dart';
import 'package:regexpo/src/views/phone_ui/home/rich_text_display_panel.dart';
import 'package:regexpo/src/views/phone_ui/user/regex_concept_list.dart';
import 'package:regexpo/src/views/phone_ui/user/common_regex_list.dart';

import '../../../blocs/fx_event/fx_event.dart';
import '../link_regex/link_regex_tab.dart';
import '../match/match_panel.dart';
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
      onDrawerChanged: (v) async {
        print("========onDrawerChanged==============");
        await Future.delayed(Duration(milliseconds: 0));
        FocusScope.of(context).unfocus();
      },
      drawer: const RecordDrawer(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: color,
            child: const RegexConfigIconsTools(
              fontSize: 13,
            ),
          ),
          const ReplaceInputField(),
          const LinkRegexTab(),
          const Expanded(child: RichTextDisplayPanel()),
          const OptionStatusBar(),
        ],
      ),
    );
  }
}

class ReplaceInputField extends StatefulWidget {
  const ReplaceInputField({super.key});

  @override
  State<ReplaceInputField> createState() => _ReplaceInputFieldState();
}

class _ReplaceInputFieldState extends State<ReplaceInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _executeReplace(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<MatchBloc>().add(ReplaceText(replacement: _controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).inputDecorationTheme.fillColor;
    RegExpConfig config = context.select((MatchBloc bloc) => bloc.state.config);
    DividerThemeData data = DividerTheme.of(context);
    List<Widget> children = [];
    if (config.keyboardMode) {
      children.add(TextFieldTapRegion(
        child: RegexSymbolsPanel(
          onSymbolTap: (symbol) {
            RegexInputEvent(symbol).emit();
          },
        ),
      ));
    }
    if (config.replaceMode) {
      children.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: data.color ?? Colors.black12,
                    width: data.thickness ?? 1))),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: color,
                  isCollapsed: true,
                  hintText: '输入替换文本...',
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _executeReplace(context),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
                child: Icon(
                  Icons.check,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return children.first;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class OptionStatusBar extends StatefulWidget {
  const OptionStatusBar({super.key});

  @override
  State<OptionStatusBar> createState() => _OptionStatusBarState();
}

class _OptionStatusBarState extends State<OptionStatusBar> {
  final Map<String, String> _configMessages = {
    'multiLine': '多行模式：^ 和 \$ 匹配每行的开始和结束',
    'caseSensitive': '大小写敏感：区分字母大小写进行匹配',
    'caseInsensitive': '大小写不敏感：忽略字母大小写进行匹配',
    'dotAll': '点通配模式：. 匹配包括换行符在内的所有字符',
    'unicode': 'Unicode模式：启用 Unicode 匹配支持',
    'replaceMode': '替换模式：启用正则替换功能',
  };

  List<String> _getActiveConfigMessages(RegExpConfig config) {
    List<String> messages = [];
    if (config.multiLine) messages.add(_configMessages['multiLine']!);
    if (config.caseSensitive) messages.add(_configMessages['caseInsensitive']!);
    if (config.dotAll) messages.add(_configMessages['dotAll']!);
    if (config.unicode) messages.add(_configMessages['unicode']!);
    if (config.replaceMode) messages.add(_configMessages['replaceMode']!);
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).dividerTheme.color ?? Colors.white;
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        final messages = _getActiveConfigMessages(state.config);
        List<Widget> children = [];

        if (messages.isNotEmpty) {
          children.add(Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: messages
                  .map((message) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ));
        }

        children.add(Divider(
          height: 1 / window.devicePixelRatio,
          thickness: 1 / window.devicePixelRatio,
          color: color,
        ));
        children.add(const StatusInfoBar());
        children.add(Divider(
          height: 1 / window.devicePixelRatio,
          thickness: 1 / window.devicePixelRatio,
          color: color,
        ));
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}

class StatusInfoBar extends StatelessWidget {
  const StatusInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        String statusText = '';
        String matchInfo = '';
        Color color = Colors.greenAccent.withOpacity(0.1);

        if (state is MatchError) {
          statusText = '错误: ${state.error}';
          color = Colors.red.withOpacity(0.1);
        } else if (state is MatchSuccess) {
          statusText = '规则正常';
          matchInfo = 'match: ${state.matchCount}   group: ${state.groupCount}';
        }

        String charCount = '字符总数: ${state.content.length}';

        List<Widget> children = [];

        if (statusText.isNotEmpty) {
          children.add(Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: state is MatchError ? Colors.red : Colors.blue,
            ),
          ));
        }

        if (matchInfo.isNotEmpty) {
          children.add(const SizedBox(width: 16));
          children.add(Text(
            matchInfo,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ));
        }
        children.add(Spacer());
        children.add(
          Text(
            charCount,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        );
        return GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.618,
                      child: const PhoneMatchPanel(),
                    ));
          },
          child: Container(
            width: double.infinity,
            color: color,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(children: children),
          ),
        );
      },
    );
  }
}
