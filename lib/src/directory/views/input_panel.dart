import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';



class InputPanel extends StatefulWidget {
  // final ValueNotifier<RegTestItem> contentTextCtrl;

  const InputPanel({Key? key})
      : super(key: key);

  @override
  _InputPanelState createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        Container(
          height: 25,
          padding: EdgeInsets.only(left: 8,right: 4),
          alignment: Alignment.centerLeft,
          color: Color(0xffF3F3F3),
          child: Row(
            children: [
              Text('输入文本',style: TextStyle(fontSize: 11),),
              Spacer(),
              Icon(Icons.delete,size: 14,color: Color(0xff7E7E7E),)
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(
          child: buildInput(themeColor, context),
        )
      ],
    );
  }
  Widget buildInput(Color themeColor, BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      // textAlign: TextAlign.start,
      // cursorColor: Colors.black,
      minLines: 40,
      maxLines: 40000,
      style: const TextStyle(fontSize: 14, backgroundColor: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: '输入需要校验的文本...',
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
        border: InputBorder.none,
      ),
      onChanged: (str) {
        // widget.contentTextCtrl.value =
        //     RegTestItem(title: '', subtitle: '', content: str);
      },
    );
  }
}

class RegTestWidget extends StatelessWidget {
  final RegExample item;
  final bool active;

  const RegTestWidget({Key? key, required this.item, this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: active
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text('${item.title}',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${item.subtitle}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ],
            ),
            Text(
              '${item.content}',
              maxLines: 2,
              style: TextStyle(fontSize: 12, color: Color(0xffCECBCD)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
