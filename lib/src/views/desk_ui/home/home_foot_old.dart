import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';
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

class RegexConfigTools extends StatelessWidget {
  final double fontSize;

  const RegexConfigTools({Key? key, this.fontSize = 11}) : super(key: key);

  final List<String> configInfo = const [
    'multiLine',
    'caseSensitive',
    'dotAll',
    'unicode',
  ];

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    RegExpConfig config = context.select<MatchBloc, RegExpConfig>(
      (value) => value.state.config,
    );
    TextStyle style = TextStyle(
      fontSize: fontSize,
      color: Colors.grey.withOpacity(0.8),
      height: 1,
    );
    TextStyle activeStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      height: 1,
    );

    return Wrap(
      children: configInfo.asMap().keys.map((int index) {
        bool active = checkActive(config, index);
        return GestureDetector(
          onTap: () => _onSelect(context, index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
            child: Text(
              configInfo[index],
              style: active ? activeStyle : style,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onSelect(BuildContext context, int index) {
    MatchBloc bloc = context.read<MatchBloc>();
    RegExpConfig cfg = bloc.state.config;
    cfg = cfg.copyWith(
      multiLine: index == 0 ? !cfg.multiLine : null,
      caseSensitive: index == 1 ? !cfg.caseSensitive : null,
      dotAll: index == 2 ? !cfg.dotAll : null,
      unicode: index == 3 ? !cfg.unicode : null,
    );
    bloc.add(UpdateRegexConfig(config: cfg));
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
    return false;
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
    TextStyle style = TextStyle(
      fontSize: fontSize,
      color: Colors.grey.withOpacity(0.8),
      height: 1,
    );
    TextStyle activeStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      height: 1,
    );

    List<Widget> children = [];

    for (int i = 0; i < assets.length; i++) {
      bool active = checkActive(config, i);
      Widget center = GestureDetector(
        onTap: () => _onSelect(context, i),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: active ? color.withValues(alpha: 0.1) : null,
                    border: Border.all(color: active ? color : Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                child: SvgPicture.asset(
                  assets[i],
                  width: 20,
                  color: active ? color : Color(0xff333333),
                ),
              )

              // Text(
              //   configInfo[index],
              //   style: active ? activeStyle : style,
              // ),
              ),
        ),
      );
      if (i == 4) {
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
        'assets/svg/copy.svg',
      ];

  List<String> get desc => [
        '多行',
        '略大小',
        '点通配',
        'unicode',
        '替换',
      ];

  void _onSelect(BuildContext context, int index) {
    if (index == 4) {
      // keyboard 图标点击事件
      _showRegexSymbolsPanel(context);
      return;
    }

    MatchBloc bloc = context.read<MatchBloc>();
    RegExpConfig cfg = bloc.state.config;
    cfg = cfg.copyWith(
      multiLine: index == 0 ? !cfg.multiLine : null,
      caseSensitive: index == 1 ? !cfg.caseSensitive : null,
      dotAll: index == 2 ? !cfg.dotAll : null,
      unicode: index == 3 ? !cfg.unicode : null,
      replaceMode: index == 5 ? !cfg.replaceMode : null,
    );
    bloc.add(UpdateRegexConfig(config: cfg));
  }

  void _showRegexSymbolsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const RegexSymbolsPanel(),
    );
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
    if (index == 5) {
      return config.replaceMode;
    }
    return false;
  }
}

class RegexSymbolsPanel extends StatelessWidget {
  const RegexSymbolsPanel({Key? key}) : super(key: key);

  // 常用正则符号列表
  static const List<Map<String, String>> symbols = [
    {'symbol': '.', 'desc': '任意字符'},
    {'symbol': '*', 'desc': '0次或多次'},
    {'symbol': '+', 'desc': '1次或多次'},
    {'symbol': '?', 'desc': '0次或1次'},
    {'symbol': '^', 'desc': '行首'},
    {'symbol': r'$', 'desc': '行尾'},
    {'symbol': r'\d', 'desc': '数字'},
    {'symbol': r'\w', 'desc': '单词字符'},
    {'symbol': r'\s', 'desc': '空白字符'},
    {'symbol': r'\D', 'desc': '非数字'},
    {'symbol': r'\W', 'desc': '非单词字符'},
    {'symbol': r'\S', 'desc': '非空白字符'},
    {'symbol': '[]', 'desc': '字符类'},
    {'symbol': '()', 'desc': '分组'},
    {'symbol': '|', 'desc': '或'},
    {'symbol': r'\b', 'desc': '单词边界'},
    {'symbol': r'\n', 'desc': '换行符'},
    {'symbol': r'\t', 'desc': '制表符'},
    {'symbol': '{n}', 'desc': '重复n次'},
    {'symbol': '{n,}', 'desc': '至少n次'},
    {'symbol': '{n,m}', 'desc': 'n到m次'},
    {'symbol': '(?=)', 'desc': '正向先行'},
    {'symbol': '(?!)', 'desc': '负向先行'},
    {'symbol': '(?<=)', 'desc': '正向后行'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '常用正则符号',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: symbols.length,
              itemBuilder: (context, index) {
                final symbol = symbols[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                            fontSize: 14,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
