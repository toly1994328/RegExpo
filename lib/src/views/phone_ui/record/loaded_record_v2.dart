import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';

import 'record_delete_panel.dart';
import 'loaded_record_v1.dart';
import 'record_edit_page.dart';

class PhoneLoadedPanelV2 extends StatefulWidget {
  final LoadedRecordState state;

  const PhoneLoadedPanelV2({
    super.key,
    required this.state,
  });

  @override
  State<PhoneLoadedPanelV2> createState() => _PhoneLoadedPanelV2State();
}

class _PhoneLoadedPanelV2State extends State<PhoneLoadedPanelV2> with SingleTickerProviderStateMixin {
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
        _scrollCtrl.position.userScrollDirection == ScrollDirection.reverse;
    return currentScroll >= (maxScroll * 0.9)&&down;
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: _scrollCtrl,
        itemCount: widget.state.records.length,
        itemExtent: 70,
        itemBuilder: (c, index) {
          Record record = widget.state.records[index];
          return Slidable(
            key: Key(record.id.toString()),
            groupTag: 'all',
            endActionPane:  ActionPane(
              motion: const BehindMotion(),
              children: _buildButtons(record),
            ),
            child: RecordPiece(record: record,),
          );
        },
      ),
    );
  }

  List<Widget> _buildButtons(Record record)=>[
    Expanded(
      child: GestureDetector(
        onTap: ()=>_showDeleteDialog(context,record),
        child: Container(
          width: 80,
          alignment: Alignment.center,
          color: Colors.red,
          child: const Text("删除",style: TextStyle(color: Colors.white),),
        ),
      ),
    ),
    Expanded(
      child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: ()=> _showEditDialog(context,record),
              child: Container(
                width: 80,
                alignment: Alignment.center,
                color: Colors.blue,
                child: const Text("修改",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      ),
    )
  ];

  void _showDeleteDialog(BuildContext context,Record record) async {
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

  void _showEditDialog(BuildContext context,Record record) {
    Slidable.of(context)?.close();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecordEditPage(record: record)),
    );
  }
}
