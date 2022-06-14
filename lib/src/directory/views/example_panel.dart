import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/content/bloc/bloc.dart';
import 'package:regexpo/src/content/bloc/event.dart';
import 'package:regexpo/src/directory/bloc/event.dart';
import 'package:regexpo/src/directory/bloc/state.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';
import 'package:regexpo/src/navigation/bloc/bloc_exp.dart';

import '../bloc/bloc.dart';

class ExamplePanel extends StatefulWidget {
  const ExamplePanel({Key? key}) : super(key: key);

  @override
  _ExamplePanelState createState() => _ExamplePanelState();
}

class _ExamplePanelState extends State<ExamplePanel> {
  // List<RegExample> items = [];

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExampleBloc>(context).add(FetchExample());
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
          child: BlocConsumer<ExampleBloc,ExampleState>(
            listener: _listenExampleState,
            builder: _buildByState,
          ),
        )
      ],
    );
  }

  Widget _buildItem(BuildContext context, RegExample example, int activeId) {
    return GestureDetector(
      onTap: () => activeExample(context, example),
      child: RegTestWidget(
        active: example.id == activeId,
        item: example,
      ),
    );
  }

  void activeExample(BuildContext context, RegExample example) {
    BlocProvider.of<SelectionCubit>(context).selectExample(example.id);
    BlocProvider.of<TabCubit>(context).addExample(example);
    BlocProvider.of<MatchBloc>(context).add(MatchRegex(content: example.content, regex: example.recommend.first));
  }

  void _listenExampleState(BuildContext context, state) {
    if (state is FullExampleState) {
      activeExample(context, state.data.first);
    }
  }

  Widget _buildByState(BuildContext context, state) {
    if (state is FullExampleState) {
      return BlocBuilder<SelectionCubit, UserSelection>(
        // buildWhen: (p, n) => p.activeExampleId != n.activeExampleId,
        builder: (_, s) => ListView.builder(
          controller: controller,
          itemCount: state.data.length,
          itemExtent: 70,
          itemBuilder: (c, index) =>
              _buildItem(c, state.data[index], s.activeExampleId),
        ),
      );
    }

    return Center(child: const Text('Empty'));
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
