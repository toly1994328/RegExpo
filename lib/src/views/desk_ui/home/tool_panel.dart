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
        {
          "type": 3,
          "title": "+",
          "rule": "reg+",
          "desc": "匹配一次或多次 reg，等价于 reg{1,}。"
        },
        {
          "type": 3,
          "title": "?",
          "rule": "reg?",
          "desc": "匹配零次或一次 reg，等价于 reg{0,1}。"
        },
        {
          "type": 4,
          "title": "非贪婪 *",
          "rule": "reg*?",
          "desc": "非贪婪匹配，尽可能少地匹配。"
        },
        {
          "type": 4,
          "title": "非贪婪 +",
          "rule": "reg+?",
          "desc": "非贪婪匹配，尽可能少地匹配。"
        },
        {"type": 4, "title": "非贪婪 ?", "rule": "reg??", "desc": "非贪婪匹配，优先不匹配。"},
        {"type": 4, "title": "非贪婪精确", "rule": "reg{n,m}?", "desc": "非贪婪的范围重复。"},
        {"type": 5, "title": "分组", "rule": "(reg)", "desc": "捕获分组，匹配并捕获结果。"},
        {
          "type": 5,
          "title": "非捕获组",
          "rule": "(?:reg)",
          "desc": "非捕获分组，匹配但不捕获。"
        },
        {
          "type": 5,
          "title": "命名分组",
          "rule": "(?<name>reg)",
          "desc": "命名捕获分组，可通过名称引用。"
        },
        {"type": 5, "title": "反向引用", "rule": r"\1", "desc": "引用第一个捕获组的内容。"},
        {
          "type": 6,
          "title": "字符范围",
          "rule": "[a-z]",
          "desc": "匹配 a 到 z 之间的任意字符。"
        },
        {
          "type": 6,
          "title": "反向字符类",
          "rule": "[^abc]",
          "desc": "匹配除 a、b、c 外的任意字符。"
        },
        {"type": 8, "title": "精确重复", "rule": "reg{n}", "desc": "精确匹配 n 次。"},
        {"type": 8, "title": "至少重复", "rule": "reg{n,}", "desc": "匹配至少 n 次。"},
        {"type": 8, "title": "范围重复", "rule": "reg{n,m}", "desc": "匹配 n 到 m 次。"},
        {"type": 9, "title": "大小写不敏感", "rule": "(?i)reg", "desc": "忽略大小写匹配。"},
        {
          "type": 9,
          "title": "多行模式",
          "rule": "(?m)reg",
          "desc": "^ 和 \$ 匹配每行的开始和结束。"
        },
        {
          "type": 9,
          "title": "单行模式",
          "rule": "(?s)reg",
          "desc": ". 匹配包括换行符在内的所有字符。"
        },
        {"type": 9, "title": "扩展模式", "rule": "(?x)reg", "desc": "忽略空白字符和注释。"},
        {"type": 10, "title": "十六进制", "rule": "\\x41", "desc": "匹配十六进制字符 A。"},
        {
          "type": 10,
          "title": "Unicode",
          "rule": "\\u0041",
          "desc": "匹配 Unicode 字符 A。"
        },
        {"type": 10, "title": "八进制", "rule": "\\101", "desc": "匹配八进制字符 A。"},
        {"type": 12, "title": "字符串开始", "rule": "\\A", "desc": "匹配整个字符串的开始。"},
        {"type": 12, "title": "字符串结束", "rule": "\\Z", "desc": "匹配整个字符串的结束。"},
        {"type": 12, "title": "绝对结束", "rule": "\\z", "desc": "匹配字符串的绝对结束。"},
        {"type": 13, "title": "命名引用", "rule": "\\k<name>", "desc": "引用命名捕获组。"},
        {"type": 13, "title": "数字引用", "rule": "\\2", "desc": "引用第二个捕获组。"},
        {"type": 15, "title": "全局修饰符", "rule": "(?g)reg", "desc": "全局匹配所有结果。"},
        {
          "type": 15,
          "title": "Unicode修饰符",
          "rule": "(?u)reg",
          "desc": "启用 Unicode 匹配模式。"
        },
        {"type": 16, "title": "空白字符类", "rule": "[\\s]", "desc": "在字符类中使用空白字符。"},
        {"type": 16, "title": "数字字符类", "rule": "[\\d]", "desc": "在字符类中使用数字字符。"},
        {"type": 16, "title": "单词字符类", "rule": "[\\w]", "desc": "在字符类中使用单词字符。"},
        {"type": 17, "title": "原子组", "rule": "(?>reg)", "desc": "原子组，不允许回溯。"},
        {
          "type": 17,
          "title": "条件匹配",
          "rule": "(?(1)yes|no)",
          "desc": "根据捕获组是否匹配来选择模式。"
        },
        {"type": 18, "title": "注释", "rule": "(?#comment)", "desc": "在正则中添加注释。"},
        {"type": 18, "title": "递归匹配", "rule": "(?R)", "desc": "递归匹配整个正则。"},
        {"type": 19, "title": "转义点号", "rule": r"\.", "desc": "匹配点号字符本身。"},
        {"type": 19, "title": "转义反斜杠", "rule": r"\\", "desc": "匹配反斜杠字符本身。"},
        {"type": 19, "title": "换行符", "rule": r"\n", "desc": "匹配换行符。"},
        {"type": 19, "title": "制表符", "rule": r"\t", "desc": "匹配制表符。"},
        {"type": 19, "title": "回车符", "rule": r"\r", "desc": "匹配回车符。"},
        {"type": 19, "title": "垂直制表符", "rule": r"\v", "desc": "匹配垂直制表符。"},
        {"type": 19, "title": "换页符", "rule": r"\f", "desc": "匹配换页符。"},
        {"type": 19, "title": "空字符", "rule": r"\0", "desc": "匹配空字符。"},
        {"type": 19, "title": "左括号", "rule": "\\(", "desc": "匹配左括号字符。"},
        {"type": 19, "title": "右括号", "rule": "\\)", "desc": "匹配右括号字符。"},
        {"type": 19, "title": "左方括号", "rule": "\\[", "desc": "匹配左方括号字符。"},
        {"type": 19, "title": "右方括号", "rule": "\\]", "desc": "匹配右方括号字符。"},
        {"type": 19, "title": "左大括号", "rule": "\\{", "desc": "匹配左大括号字符。"},
        {"type": 19, "title": "右大括号", "rule": "\\}", "desc": "匹配右大括号字符。"},
        {"type": 19, "title": "管道符", "rule": "\\|", "desc": "匹配管道符字符。"},
        {"type": 19, "title": "加号", "rule": "\\+", "desc": "匹配加号字符。"},
        {"type": 19, "title": "星号", "rule": "\\*", "desc": "匹配星号字符。"},
        {"type": 19, "title": "问号", "rule": "\\?", "desc": "匹配问号字符。"},
        {"type": 19, "title": "脱字符", "rule": "\\^", "desc": "匹配脱字符字符。"},
        {"type": 19, "title": "美元符", "rule": "\\\$", "desc": "匹配美元符字符。"},
      ];

  final double fontSize;

  const RegexNoteList({super.key, this.fontSize = 12});

  Map<int, String> get categoryNames => {
        0: '基本匹配',
        1: '位置匹配',
        2: '字符类',
        3: '量词',
        4: '非贪婪',
        5: '分组捕获',
        6: '字符范围',
        8: '精确量词',
        9: '修饰符',
        10: '字符编码',
        12: '字符串边界',
        13: '高级引用',
        15: '高级修饰符',
        16: '字符类内简写',
        17: '高级特性',
        18: '其他特性',
        19: '转义字符',
      };

  @override
  Widget build(BuildContext context) {
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    for (var item in data) {
      int type = item['type'];
      if (!groupedData.containsKey(type)) {
        groupedData[type] = [];
      }
      groupedData[type]!.add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: groupedData.keys.length,
      itemBuilder: (context, index) {
        int type = groupedData.keys.elementAt(index);
        List<Map<String, dynamic>> items = groupedData[type]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                categoryNames[type] ?? '其他',
                style: TextStyle(
                  fontSize: fontSize + 1,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (type == 19)
              _buildEscapeGrid(items)
            else
              ...items.map((item) => _buildItem(item)),
          ],
        );
      },
    );
  }

  Widget _buildEscapeGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item['rule']}',
                  style: TextStyle(
                    fontSize: fontSize * 0.8,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['title'],
                style: TextStyle(
                  fontSize: fontSize * 0.75,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item['title'],
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item['rule']}',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${item['desc']}",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
