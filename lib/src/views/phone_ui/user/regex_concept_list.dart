import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../user/info_page.dart';

class RegexConceptList extends StatelessWidget {
  const RegexConceptList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildConceptItem(
          context,
          CupertinoIcons.question_diamond,
          '什么是正则表达式?',
          '正则表达式基础概念介绍',
          () => _showRegexInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.code,
          '元字符和特殊字符',
          '点号、脱字符、美元符等特殊字符',
          () => _showMetaCharInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.group,
          '分组和捕获',
          '捕获组、非捕获组、命名分组等',
          () => _showGroupInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.repeat,
          '量词和重复',
          '星号、加号、问号、花括号等',
          () => _showQuantifierInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.location_on,
          '位置匹配和边界',
          '行边界、单词边界、字符串边界',
          () => _showPositionInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.flag,
          '正则表达式修饰符',
          '大小写敏感、多行模式、全局匹配等',
          () => _showModifierInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.swap_horiz,
          '转义字符',
          '反斜杠转义、特殊字符匹配',
          () => _showEscapeInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.alt_route,
          '选择和分支',
          '管道符、多选一匹配模式',
          () => _showAlternationInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.speed,
          '贪婪与非贪婪',
          '匹配策略、性能优化',
          () => _showGreedyInfo(context),
        ),
        _buildConceptItem(
          context,
          Icons.category,
          '字符类和范围',
          '方括号表达式、字符范围匹配',
          () => _showCharClassInfo(context),
        ),
      ],
    );
  }

  Widget _buildConceptItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
        trailing:
            Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
        onTap: onTap,
      ),
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

  void _showModifierInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '正则表达式修饰符',
          content:
              '修饰符用于改变正则表达式的匹配行为和模式。\n\n常用修饰符：\n\n• i - 忽略大小写（Case Insensitive）\n• g - 全局匹配（Global）\n• m - 多行模式（Multiline）\n• s - 单行模式（Dotall）\n• x - 扩展模式（Extended）\n• u - Unicode 模式\n\n使用方式：\n• /pattern/flags - JavaScript 风格\n• (?flags)pattern - 内联修饰符\n• (?flags:pattern) - 局部修饰符\n\n示例：\n• /hello/i - 匹配 "hello"、"Hello"、"HELLO"\n• /\\\\d+/g - 全局匹配所有数字\n• /^\\\\w+/m - 多行模式下匹配每行开头的单词',
        ),
      ),
    );
  }

  void _showEscapeInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '转义字符',
          content:
              '转义字符用于匹配具有特殊意义的字符或表示不可见字符。\n\n基本转义：\n\n• \\\\\\\\ - 匹配反斜杠本身\n• \\\\. - 匹配点号本身\n• \\\\* - 匹配星号本身\n• \\\\+ - 匹配加号本身\n• \\\\? - 匹配问号本身\n• \\\\^ - 匹配脱字符本身\n• \\\\\$ - 匹配美元符本身\n\n特殊字符：\n• \\\\n - 换行符\n• \\\\r - 回车符\n• \\\\t - 制表符\n• \\\\v - 垂直制表符\n• \\\\f - 换页符\n• \\\\0 - 空字符\n\n示例：\n• \\\\. - 匹配句号\n• \\\\\$ - 匹配美元符号\n• \\\\n - 匹配换行符',
        ),
      ),
    );
  }

  void _showAlternationInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '选择和分支',
          content:
              '选择和分支允许在多个模式中选择一个进行匹配。\n\n基本语法：\n\n• | - 管道符，表示“或”关系\n• (a|b) - 匹配 a 或 b\n• (cat|dog) - 匹配 "cat" 或 "dog"\n\n复杂示例：\n• (https?|ftp) - 匹配 "http"、"https" 或 "ftp"\n• (Mr|Mrs|Ms)\\\\. - 匹配称谓\n• (\\\\d{4}|\\\\d{2}) - 匹配 4 位或 2 位数字\n\n优先级：\n• 从左到右逐个尝试\n• 找到第一个匹配即停止\n• 使用括号控制优先级\n\n注意事项：\n• 避免过多分支影响性能\n• 将常用选项放在前面\n• 使用非捕获组优化性能',
        ),
      ),
    );
  }

  void _showGreedyInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '贪婪与非贪婪',
          content:
              '贪婪和非贪婪描述了量词的匹配策略。\n\n贪婪匹配（默认）：\n\n• * - 尽可能多地匹配\n• + - 尽可能多地匹配\n• ? - 优先匹配一次\n• {n,m} - 尽可能匹配更多次\n\n非贪婪匹配：\n• *? - 尽可能少地匹配\n• +? - 尽可能少地匹配\n• ?? - 优先不匹配\n• {n,m}? - 尽可能匹配更少次\n\n实际示例：\n• 文本："<div>content</div>"\n• <.*> - 贪婪，匹配整个字符串\n• <.*?> - 非贪婪，只匹配 "<div>"\n\n性能影响：\n• 贪婪匹配可能导致回溯\n• 非贪婪通常更高效\n• 选择合适的策略很重要',
        ),
      ),
    );
  }

  void _showCharClassInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfoPage(
          title: '字符类和范围',
          content:
              '字符类用于匹配一组字符中的任意一个。\n\n基本语法：\n\n• [abc] - 匹配 a、b 或 c\n• [a-z] - 匹配小写字母\n• [A-Z] - 匹配大写字母\n• [0-9] - 匹配数字\n• [a-zA-Z0-9] - 匹配字母数字\n\n反向字符类：\n• [^abc] - 匹配除 a、b、c 外的字符\n• [^0-9] - 匹配非数字字符\n• [^a-zA-Z] - 匹配非字母字符\n\n特殊字符在字符类中：\n• [-] - 连字符，放在开头或结尾匹配本身\n• [\\\\]] - 匹配右方括号\n• [\\\\^] - 匹配脱字符\n\n实用示例：\n• [\\\\w\\\\s] - 匹配单词字符或空白\n• [a-z]{2,4} - 匹配 2-4 个小写字母\n• [0-9a-fA-F] - 匹配十六进制数字',
        ),
      ),
    );
  }
}
