import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:regexpo/src/models/models.dart';

import 'delete_record_panel.dart';
import 'loaded_record_v2.dart';
import 'record_edit_page.dart';
import 'record_piece.dart';

class SlideRecordItem extends StatelessWidget {
  final Record record;
  final ValueNotifier<double>? factor ;
  final VoidCallback? requestClose ;
  const SlideRecordItem({Key? key, required this.record,this.factor,this.requestClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeOperation(
        factor: factor,
        actions: [
          GestureDetector(
            onTap: ()=>_showDeleteDialog(context),
            child: Container(
              width: 80,
              alignment: Alignment.center,
              color: Colors.red,
              child: const Text("删除",style: TextStyle(color: Colors.white),),
            ),
          ),
          GestureDetector(
            onTap: ()=>_showEditDialog(context),
            child: Container(
              width: 80,
              alignment: Alignment.center,
              color: Colors.blue,
              child: const Text("修改",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
        item: RecordPiece(record: record),
    );
  }

  void _showDeleteDialog(BuildContext context) async {
    requestClose?.call();
    Color color = Theme.of(context).backgroundColor;
    await showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: color,
              child: PhoneDeleteRecord(
                model: record,
              ),
            ));
  }

  void _showEditDialog(BuildContext context) {
    requestClose?.call();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecordEditPage(record: record)),
    );
  }
}

class SwipeOperation extends StatelessWidget {
  final Widget item;
  final List<Widget> actions;
  final ValueNotifier<double>? factor;

  const SwipeOperation({
    super.key,
    required this.item,
    required this.factor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: SwipeFlowDelegate(factor),
      children: [item, Row(children: actions)],
    );
  }
}

class SwipeFlowDelegate extends FlowDelegate {
  final ValueListenable<double>? factor;

  SwipeFlowDelegate(this.factor) : super(repaint: factor);

  @override
  void paintChildren(FlowPaintingContext context) {
    if (factor == null || factor!.value == 0) {
      context.paintChild(0);
      return;
    }
    Size size = context.size;
    Matrix4 m0 = Matrix4.translationValues(factor!.value * size.width, 0, 0);
    context.paintChild(0, transform: m0);
    Matrix4 m1 = Matrix4.translationValues(
        size.width + factor!.value * size.width, 0, 0);
    if (factor!.value != 0) {
      context.paintChild(1, transform: m1);
    }
  }

  @override
  bool shouldRepaint(covariant SwipeFlowDelegate oldDelegate) {
    return oldDelegate.factor?.value != factor?.value;
  }
}
