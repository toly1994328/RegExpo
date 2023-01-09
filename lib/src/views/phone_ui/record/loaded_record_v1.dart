import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/phone_ui/record/slide_record_item.dart';

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
