import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';


class ExamplePanel extends StatefulWidget {
  const ExamplePanel({Key? key}) : super(key: key);

  @override
  _ExamplePanelState createState() => _ExamplePanelState();
}

class _ExamplePanelState extends State<ExamplePanel> {
  List<RegExample> items = [];
  int _position = 0;
  bool isInput = false;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          padding: EdgeInsets.only(left: 8,right: 4),
          alignment: Alignment.centerLeft,
          color: Color(0xffF3F3F3),
          child: Row(
            children: [
              Text('选择案例',style: TextStyle(fontSize: 11),),
              Spacer(),
              Icon(Icons.add,size: 16,color: Color(0xff7E7E7E),)
            ],
          ),
        ),
        Gap.dividerH,
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemExtent: 70,
            itemBuilder: _buildItem,
          ),
        )
      ],
    );
  }

  void _loadTestData() async {
    String dataStr = await rootBundle.loadString('assets/data.json');
    items = json
        .decode(dataStr)
        .map<RegExample>((e) => RegExample.fromJson((e)))
        .toList();
    // _position = items.indexWhere((element) => element.title == widget.contentTextCtrl.value.title);
    if (mounted) setState(() {});
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print('=======${items[index].title}====');
        // widget.contentTextCtrl.value = items[index];
        setState(() {
          _position = index;
        });
      },
      child: RegTestWidget(
        active: _position == index,
        item: items[index],
      ),
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
            Text('${item.title}',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            // Text('${item.subtitle}',
            //     style: TextStyle(
            //         fontSize: 10,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.grey)),

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
