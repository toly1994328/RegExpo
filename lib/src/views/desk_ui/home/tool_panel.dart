import 'package:flutter/material.dart';
import 'package:regexpo/src/app/res/gap.dart';

class ToolPanel extends StatelessWidget {
  const ToolPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 25,
          padding: const EdgeInsets.only(left: 8, right: 4),
          alignment: Alignment.centerLeft,
          color: color,
          child: Row(
            children: const [
              Text(
                '正则语法速查',
                style: TextStyle(fontSize: 11),
              ),
              Spacer(),
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(child: RegexNoteList())
      ],
    );
  }
}

class RegexNoteList extends StatelessWidget {
  // type: 0 正则关键字
  // type: 1 位置匹配
  // type: 2 简写规则
  List<Map<String, dynamic>> get data => const [
        {
          "type": 0,
          "title": "横向排列",
          "rule": "reg1reg2",
          "desc": "内容需连续匹配若干规则。"
        },
        {
          "type": 0,
          "title": "重复匹配",
          "rule": "reg{m,n}",
          "desc": "内容需连续至少匹配 m 次，至多匹配 n 次。"
        },
        {
          "type": 0,
          "title": "或分支",
          "rule": "reg1|reg2",
          "desc": "内容满足任意一个正则即可匹配。"
        },
        {
          "type": 0,
          "title": "单字符或",
          "rule": "[c1c2c3]",
          "desc": "盛放单字符匹配的正则，内容满足任意一个即可匹配。"
        },
        {
          "type": 1,
          "title": "行首位置",
          "rule": "^",
          "desc": "匹配行首位置，注意多行模式的开关区别。"
        },
        {
          "type": 1,
          "title": "行尾位置",
          "rule": r"$",
          "desc": "匹配行尾位置，注意多行模式的开关区别。"
        },
        {"type": 1, "title": "单词边距", "rule": r"\b", "desc": "不匹配内容，只匹配单词边界位置。"},
        {
          "type": 1,
          "title": "非单词边距",
          "rule": r"\B",
          "desc": "匹配行尾位置，只匹配非单词边界位置。"
        },
        {
          "type": 1,
          "title": "正则位置(前)",
          "rule": "(?=reg)",
          "desc": "符合reg的前方位置。"
        },
        {
          "type": 1,
          "title": "正则位置(后)",
          "rule": "(?<=reg)",
          "desc": "符合reg的后方位置。"
        },
        {
          "type": 1,
          "title": "非正则位置(前)",
          "rule": "(?!reg)",
          "desc": "不符合reg的前方位置。"
        },
        {
          "type": 1,
          "title": "非正则位置(后)",
          "rule": "(?<!reg)",
          "desc": "不符合reg的后方位置。"
        },
        {"type": 2, "title": "数字", "rule": r"\d", "desc": "匹配数字，等价于 [0-9]。"},
        {"type": 2, "title": "非数字", "rule": r"\D", "desc": "匹配非数字，等价于[^0-9]。"},
        {"type": 2, "title": "单词", "rule": r"\w", "desc": "匹配字母或数字或下划线或汉字。"},
        {
          "type": 3,
          "title": r"非单词",
          "rule": r"\w",
          "desc": r"匹配非字母或数字或下划线或汉字，等价于 [^\w]。"
        },
        {
          "type": 3,
          "title": "空白字符",
          "rule": r"\s",
          "desc": r"匹配空白字符，\n、\r、\t、\v、\f。"
        },
        {
          "type": 3,
          "title": "非空白字符",
          "rule": r"\S",
          "desc": r"匹配非空白字符，等价于 [^\s]。"
        },
        {
          "type": 3,
          "title": "通配符",
          "rule": ".",
          "desc": r"通配符，匹配除四个字符外的所有字符，等价于[^\n\r\u2028\u2029]。"
        },
        {
          "type": 3,
          "title": r"*",
          "rule": "reg*",
          "desc": r"示可以连续匹配任意次 reg，等价于 reg{0,}。"
        },
      ];

  final double fontSize;

  const RegexNoteList({super.key, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) {
        Map<String, dynamic> item = data[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    '${item['rule']}',
                    style: TextStyle(fontSize: fontSize, color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  "${item['desc']}",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: data.length,
    );
  }
}
