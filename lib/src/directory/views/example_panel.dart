import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';
import 'package:regexpo/src/navigation/bloc/bloc_exp.dart';

class ExamplePanel extends StatefulWidget {
  const ExamplePanel({Key? key}) : super(key: key);

  @override
  _ExamplePanelState createState() => _ExamplePanelState();
}

class _ExamplePanelState extends State<ExamplePanel> {
  List<RegExample> items = [];
  int _position = 0;
  bool isInput = false;
  final ScrollController controller = ScrollController();
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
          child: BlocBuilder<SelectionCubit, UserSelection>(
            buildWhen: (p, n) => p.activeExampleId != n.activeExampleId,
            builder: (_, s) => ListView.builder(
              controller: controller,
              itemCount: items.length,
              itemExtent: 70,
              itemBuilder: (c, index) => _buildItem(c, index, s.activeExampleId),
            ),
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

  Widget _buildItem(BuildContext context, int index, int activeId) {
    RegExample example = items[index];
    return GestureDetector(
      onTap: () {
        BlocProvider.of<SelectionCubit>(context).selectExample(example.id);
        BlocProvider.of<TabCubit>(context).addExample(example);

        // print('=======${items[index].title}====');
        // // widget.contentTextCtrl.value = items[index];
        // setState(() {
        //   _position = index;
        // });
      },
      child: RegTestWidget(
        active: example.id == activeId,
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
