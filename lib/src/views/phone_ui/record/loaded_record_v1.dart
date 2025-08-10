import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';

import 'record_delete_panel.dart';
import 'record_edit_page.dart';

class PhoneLoadedPanelV1 extends StatefulWidget {
  final LoadedRecordState state;

  const PhoneLoadedPanelV1({
    super.key,
    required this.state,
  });

  @override
  State<PhoneLoadedPanelV1> createState() => _PhoneLoadedPanelV1State();
}

class _PhoneLoadedPanelV1State extends State<PhoneLoadedPanelV1> with SingleTickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  ValueNotifier<double> factor = ValueNotifier(0);
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_shouldLoadMore) {
      context.read<RecordBloc>().loadRecord(
          operation: LoadType.more
      );
    }
  }

  bool get _shouldLoadMore {
    if (!_scrollCtrl.hasClients) return false;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    final currentScroll = _scrollCtrl.offset;
    final bool down =
        _scrollCtrl.position.userScrollDirection
            ==ScrollDirection.reverse;
    return currentScroll >= (maxScroll * 0.9)&&down;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: _scrollCtrl,
      itemCount: widget.state.records.length,
      itemExtent: 70,
      itemBuilder: (c, index) {
        return GestureDetector(
          onHorizontalDragDown: (e) => _onDragDown(e, index),
          onHorizontalDragUpdate: _onPanUpdate,
          onHorizontalDragEnd: _onPanEnd,
          child: SlideRecordItem(
            requestClose: close,
            factor: _activeIndex == index ? factor : null,
            key: Key(widget.state.records[index].id.toString()),
            record: widget.state.records[index],
          ),
        );
      },
    );
  }

  void _onDragDown(DragDownDetails e, int index) async {
    if (index != _activeIndex && _offsetX != 0) {
      await close();
    }
    _activeIndex = index;
    setState(() {});
    if (_closeTask != null) {
      _closeTask?.complete();
      _closeTask = null;
    }
  }

  int _activeIndex = -1;
  double _offsetX = 0;
  double slideWidth = 160;

  void _onPanUpdate(DragUpdateDetails details) {
    _offsetX += details.delta.dx;
    if (_offsetX > 0) {
      _offsetX = 0;
    } else if (_offsetX.abs() > slideWidth) {
      _offsetX = -slideWidth;
    }
    factor.value = _offsetX / MediaQuery.of(context).size.width;
  }

  void _onPanEnd(DragEndDetails details) async {
    if (_offsetX.abs() > slideWidth / 2) {
      open();
    } else {
      close();
    }
  }

  Completer<void>? _closeTask;

  // 动画打开，剩余部分
  Future<void> open() async {
    if (_closeTask != null) {
      await _closeTask!.future;
    }
    Animation<double> anim = Tween<double>(begin: _offsetX, end: -slideWidth).animate(_ctrl);
    anim.addListener(() {
      factor.value = anim.value / MediaQuery.of(context).size.width;
    });
    await _ctrl.forward(from: 0);
    _offsetX = -slideWidth;
  }


  // 动画关闭
  Future<void> close() async {
    _closeTask = Completer();
    Animation<double> anim = Tween<double>(begin: _offsetX, end: 0).animate(_ctrl);
    anim.addListener(() {
      factor.value = anim.value / MediaQuery.of(context).size.width;
    });
    await _ctrl.forward(from: 0);
    _offsetX = 0;
  }
}

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
    Color color = Theme.of(context).colorScheme.surface;
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

class RecordPiece extends StatelessWidget {
  final Record record;

  const RecordPiece({Key? key,required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).scaffoldBackgroundColor;
    NavigationRailThemeData data = Theme.of(context).navigationRailTheme;
    TextStyle? title = data.unselectedLabelTextStyle;

    return Container(
        color: color,
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(record.title, style: title?.copyWith(fontSize: 14)),
            Text(
              record.content,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}