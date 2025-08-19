import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'info_page.dart';

/// create by 张风捷特烈 on 2020-03-26
/// contact me by email 1981462002@qq.com
/// 说明:

class MePageItem extends StatelessWidget {
  final Color color;

  const MePageItem({Key? key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildChild(context);
  }

  Widget _buildChild(BuildContext context) {
    Color color = Theme.of(context).dialogBackgroundColor;
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 10,
          child: ColoredBox(color: color),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'RegExpo 是一款基于 '),
                TextSpan(
                  text: 'Flutter',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' 构建的，'),
                TextSpan(
                  text: '全平台',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '文本'),
                TextSpan(
                  text: '正则表达式',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '交互匹配应用。可以帮助开发者'),
                TextSpan(
                  text: '可视化',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '地感知，文本正则匹配结果，对文本处理、正则学习都大有帮助。'),
              ],
            ),
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        _buildItem(
          context,
          CupertinoIcons.arrow_branch,
          '项目开源地址',
          onTap: () => _showProjectInfo(context),
        ),
        SizedBox(
          height: 4,
          child: ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        _buildItem(
          context,
          CupertinoIcons.question_diamond,
          '什么是正则表达式?',
          onTap: () => _showRegexInfo(context),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    Color color = Theme.of(context).dialogBackgroundColor;
    return ListTile(
      tileColor: color,
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing:
          Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
      onTap: onTap,
    );
  }

  void _showRegexInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '什么是正则表达式?',
          content:
              '正则表达式（Regular Expression，简称 Regex 或 RegExp）是一种强大的文本处理工具，用于匹配、查找、替换和验证字符串中的特定模式。\n\n正则表达式由普通字符和特殊字符（元字符）组成，可以描述复杂的字符串模式。它广泛应用于：\n\n• 数据验证（如邮箱、电话号码格式验证）\n• 文本搜索和替换\n• 数据提取和解析\n• 日志分析\n• 代码重构\n\n常用元字符包括：\n• . 匹配任意字符\n• * 匹配前面字符0次或多次\n• + 匹配前面字符1次或多次\n• ? 匹配前面字符0次或1次\n• [] 字符类，匹配方括号内的任意字符\n• ^ 匹配行首\n• \$ 匹配行尾\n\n掌握正则表达式可以大大提高文本处理效率，是程序员必备的技能之一。',
        ),
      ),
    );
  }

  void _showProjectInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '项目开源地址',
          content:
              'RegExpo 是一个完全开源的项目，基于 Flutter 框架开发，支持多平台运行。\n\n项目特点：\n• 跨平台支持（Android、iOS、HarmonyOS、Windows、macOS、Linux、Web）\n• 实时正则匹配和高亮显示\n• 丰富的正则表达式示例\n• 直观的匹配结果展示\n• 支持正则表达式语法速查\n• 本地数据存储\n\n欢迎访问 GitHub 仓库查看源代码、提交问题或贡献代码。如果这个项目对您有帮助，请给我们一个 Star ⭐',
          url: 'https://github.com/toly1994328/RegExpo',
        ),
      ),
    );
  }

  void _showMetaCharInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '元字符和特殊字符',
          content:
              '元字符是正则表达式中具有特殊意义的字符，用于定义匹配模式。\n\n常用元字符：\n\n• . 点号 - 匹配除换行符外的任意字符\n• ^ 脱字符 - 匹配行的开始\n• \$ 美元符 - 匹配行的结束\n• \\\\ 反斜杠 - 转义字符，用于匹配特殊字符\n\n字符类：\n• [abc] - 匹配 a、b 或 c 中的任意一个\n• [a-z] - 匹配任意小写字母\n• [^abc] - 匹配除 a、b、c 外的任意字符\n\n预定义字符类：\n• \\\\d - 匹配数字 [0-9]\n• \\\\w - 匹配单词字符 [a-zA-Z0-9_]\n• \\\\s - 匹配空白字符\n• \\\\D - 匹配非数字\n• \\\\W - 匹配非单词字符\n• \\\\S - 匹配非空白字符',
        ),
      ),
    );
  }

  void _showGroupInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '分组和捕获',
          content:
              '分组允许您将正则表达式的一部分作为一个单元来处理，并可以捕获匹配的内容。\n\n基本分组：\n• (pattern) - 捕获分组，匹配 pattern 并捕获结果\n• (?:pattern) - 非捕获分组，匹配但不捕获\n\n命名分组：\n• (?<name>pattern) - 命名捕获分组\n• (?P<name>pattern) - Python 风格命名分组\n\n反向引用：\n• \\\\1, \\\\2 - 引用第 1、第 2 个捕获分组\n• \\\\k<name> - 引用命名分组\n\n先行断言：\n• (?=pattern) - 正向先行断言\n• (?!pattern) - 负向先行断言\n• (?<=pattern) - 正向后行断言\n• (?<!pattern) - 负向后行断言\n\n示例：\n• (\\\\d{4})-(\\\\d{2})-(\\\\d{2}) - 匹配日期格式并捕获年月日',
        ),
      ),
    );
  }

  void _showQuantifierInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '量词和重复',
          content:
              '量词用于指定字符或分组的重复次数。\n\n基本量词：\n• * - 匹配 0 次或多次（等价于 {0,}）\n• + - 匹配 1 次或多次（等价于 {1,}）\n• ? - 匹配 0 次或1 次（等价于 {0,1}）\n\n精确量词：\n• {n} - 精确匹配 n 次\n• {n,} - 匹配至少 n 次\n• {n,m} - 匹配 n 到 m 次\n\n贪婪与非贪婪：\n• *? - 非贪婪匹配 0 次或多次\n• +? - 非贪婪匹配 1 次或多次\n• ?? - 非贪婪匹配 0 次或1 次\n• {n,m}? - 非贪婪匹配 n 到 m 次\n\n示例：\n• a* - 匹配 0 个或多个 a\n• \\\\d{3,5} - 匹配 3 到 5 个数字\n• .*? - 非贪婪匹配任意字符',
        ),
      ),
    );
  }

  void _showPositionInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '位置匹配和边界',
          content:
              '位置匹配用于指定匹配在文本中的位置，而不是匹配实际的字符。\n\n行边界：\n• ^ - 匹配行的开始位置\n• \$ - 匹配行的结束位置\n\n单词边界：\n• \\\\b - 匹配单词边界（单词与非单词字符之间）\n• \\\\B - 匹配非单词边界\n\n字符串边界：\n• \\\\A - 匹配字符串的开始\n• \\\\Z - 匹配字符串的结束\n• \\\\z - 匹配字符串的绝对结束\n\n示例：\n• ^Hello - 匹配以 "Hello" 开始的行\n• world\$ - 匹配以 "world" 结束的行\n• \\\\bcat\\\\b - 匹配完整的单词 "cat"\n• \\\\Bcat\\\\B - 匹配在单词内部的 "cat"',
        ),
      ),
    );
  }
}
