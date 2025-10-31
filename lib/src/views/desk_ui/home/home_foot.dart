import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:regexpo/src/blocs/fx_event/fx_event.dart';

import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import '../../../app/iconfont/toly_icon.dart';
import 'home_top_bar.dart';

class FootBar extends StatelessWidget {
  const FootBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Container(
      height: 20,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Row(
        children: [
          const RegexConfigIconsTools(),
          const Spacer(),
          const ResultShower(),
        ],
      ),
    );
  }
}

class ResultShower extends StatelessWidget {
  const ResultShower({Key? key}) : super(key: key);

  final TextStyle errorStyle = const TextStyle(fontSize: 11, color: Colors.red);
  final TextStyle style = const TextStyle(fontSize: 11, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(builder: buildInfoByState);
  }

  Widget buildInfoByState(BuildContext context, MatchState state) {
    if (state is MatchError) {
      return Text(
        state.error,
        style: errorStyle,
      );
    }
    if (state is MatchSuccess) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          Text(
            '规则正常',
            style: style,
          ),
          Text(
            'match: ${state.matchCount}',
            style: style,
          ),
          Text(
            'group: ${state.groupCount}',
            style: style,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class RegexConfigIconsTools extends StatelessWidget {
  final double fontSize;

  const RegexConfigIconsTools({Key? key, this.fontSize = 11}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    RegExpConfig config = context.select<MatchBloc, RegExpConfig>(
      (value) => value.state.config,
    );
    ThemeMode mode =
        context.select((AppConfigBloc bloc) => bloc.state.themeMode);
    List<Widget> children = [];

    Color iconColor = mode == ThemeMode.dark ? Colors.white : Color(0xff333333);
    Color borderColor = mode == ThemeMode.dark ? Colors.white : Colors.black;

    for (int i = 0; i < assets.length; i++) {
      bool active = checkActive(config, i);
      Widget center = GestureDetector(
        onTap: () => _onSelect(context, i),
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: active ? color.withValues(alpha: 0.1) : null,
                border: Border.all(color: active ? color : borderColor),
                borderRadius: BorderRadius.circular(8)),
            child: SvgPicture.asset(
              assets[i],
              width: 20,
              color: active ? color : iconColor,
            ),
          ),
        ),
      );
      if (i != 5) {
        center = TextFieldTapRegion(child: center);
      }
      children.add(Expanded(child: center));
      if (i == 3) {
        children.add(Container(
          height: 24,
          child: VerticalDivider(),
        ));
      }
    }

    Widget icon = mode == ThemeMode.dark
        ? const Icon(TolyIcon.wb_sunny, size: 20)
        : const Icon(TolyIcon.dark, size: 20);

    children.add(Expanded(
      child: GestureDetector(
        onTap: () {
          LinkRegexBloc bloc = context.read<LinkRegexBloc>();
          Record? record = context.read<RecordBloc>().state.active;
          if (record == null) return;
          String regex = context.read<MatchBloc>().state.pattern;
          if (regex.isEmpty) return;
          bloc.insert(regex, record.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('正则表达式已保存')),
          );
        },
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(TolyIcon.save, size: 20),
          ),
        ),
      ),
    ));

    children.add(Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<AppConfigBloc>().switchThemeMode();
        },
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8)),
            child: icon,
          ),
        ),
      ),
    ));

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(children: children),
    );
  }

  List<String> get assets => [
        'assets/svg/mutiline.svg',
        'assets/svg/caseSensitive.svg',
        'assets/svg/dotAll.svg',
        'assets/svg/unicode.svg',
        'assets/svg/keyboard.svg',
        'assets/svg/replace.svg',
      ];

  void _onSelect(BuildContext context, int index) {
    MatchBloc bloc = context.read<MatchBloc>();
    RegExpConfig cfg = bloc.state.config;

    if (index == 6) {
      // 拷贝功能 - 这里需要获取要拷贝的文本
      // String textToCopy = bloc.state.content; // 替换为实际要拷贝的文本
      // Clipboard.setData(ClipboardData(text: textToCopy));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('已复制到剪贴板')),
      // );
      return;
    }

    bool? isKeyboard = index == 4 ? !cfg.keyboardMode : null;
    if (isKeyboard == true) {
      FocusEvent().emit();
    }
    cfg = cfg.copyWith(
      multiLine: index == 0 ? !cfg.multiLine : null,
      caseSensitive: index == 1 ? !cfg.caseSensitive : null,
      dotAll: index == 2 ? !cfg.dotAll : null,
      unicode: index == 3 ? !cfg.unicode : null,
      keyboardMode: isKeyboard,
      replaceMode: index == 5 ? !cfg.replaceMode : null,
    );
    bloc.add(UpdateRegexConfig(config: cfg));
  }

  void _showRegexSymbolsPanel(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   barrierColor: Colors.transparent,
    //   builder: (ctx) => RegexSymbolsPanel(
    //     onSymbolTap: (symbol) {
    //       RegexInputEvent(symbol).emit();
    //     },
    //   ),
    // );
  }

  bool checkActive(RegExpConfig config, index) {
    if (index == 0) {
      return config.multiLine;
    }
    if (index == 1) {
      return config.caseSensitive;
    }
    if (index == 2) {
      return config.dotAll;
    }
    if (index == 3) {
      return config.unicode;
    }
    if (index == 4) {
      return config.keyboardMode;
    }
    if (index == 5) {
      return config.replaceMode;
    }
    return false;
  }
}

class RegexSymbolsPanel extends StatelessWidget {
  final ValueChanged<String>? onSymbolTap;

  const RegexSymbolsPanel({Key? key, this.onSymbolTap}) : super(key: key);

  static const List<Map<String, String>> symbols = [
    {'symbol': '.', 'desc': '任意字符'},
    {'symbol': '*', 'desc': '0次或多次'},
    {'symbol': '+', 'desc': '1次或多次'},
    {'symbol': '?', 'desc': '0次或1次'},
    {'symbol': '^', 'desc': '行首'},
    {'symbol': r'$', 'desc': '行尾'},
    {'symbol': '|', 'desc': '或'},
    {'symbol': '[', 'desc': '字符类开始'},
    {'symbol': ']', 'desc': '字符类结束'},
    {'symbol': '(', 'desc': '分组开始'},
    {'symbol': ')', 'desc': '分组结束'},
    {'symbol': '{', 'desc': '量词开始'},
    {'symbol': '}', 'desc': '量词结束'},
    {'symbol': r'\', 'desc': '转义符'},
    {'symbol': '[^]', 'desc': '否定字符'},
    {'symbol': 'd', 'desc': '数字'},
    {'symbol': 'w', 'desc': '单词字符'},
    {'symbol': 's', 'desc': '空白字符'},
    {'symbol': 'D', 'desc': '非数字'},
    {'symbol': 'W', 'desc': '非单词字符'},
    {'symbol': 'S', 'desc': '非空白字符'},
    {'symbol': 'b', 'desc': '单词边界'},
    {'symbol': 'n', 'desc': '换行符'},
    {'symbol': 't', 'desc': '制表符'},
    {'symbol': '=', 'desc': '正向先行'},
    {'symbol': '{n}', 'desc': '精确n次'},
    {'symbol': '{n,}', 'desc': '至少n次'},
    {'symbol': '{n,m}', 'desc': 'n到m次'},
    {'symbol': '(?:)', 'desc': '非捕获分组'},
    {'symbol': '(?<>)', 'desc': '命名分组'},
    {'symbol': '＜', 'desc': '光标左移'},
    {'symbol': '＞', 'desc': '光标右移'},
    {'symbol': '←', 'desc': '删除'},
    {'symbol': '☇', 'desc': '撤回'},
    {'symbol': '✖', 'desc': '清空'},
  ];

  @override
  Widget build(BuildContext context) {
    DividerThemeData data = DividerTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: data.color ?? Colors.black12,
                  width: data.thickness ?? 1))),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.5,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: symbols.length,
        itemBuilder: (context, index) =>
            _buildSymbolItem(context, symbols[index]),
      ),
    );
  }

  Widget _buildSymbolItem(BuildContext context, Map<String, String> symbol) {
    return GestureDetector(
      onTap: () {
        String insertSymbol = symbol['symbol']!;
        if (['d', 'w', 's', 'D', 'W', 'S', 'b', 'n', 't']
            .contains(insertSymbol)) {
          insertSymbol = '\\$insertSymbol';
        }
        print('点击符号: ${symbol['symbol']}, 插入符号: $insertSymbol');
        onSymbolTap?.call(insertSymbol);
        print('回调已调用');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              symbol['symbol']!,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              symbol['desc']!,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
