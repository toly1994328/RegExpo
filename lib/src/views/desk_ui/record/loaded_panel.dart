import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';

import 'record_item.dart';

class LoadedPanel extends StatefulWidget {
  final LoadedRecordState state;
  final ValueChanged<Record> onSelectRecord;

  const LoadedPanel({
    super.key,
    required this.state,
    required this.onSelectRecord,
  });

  @override
  State<LoadedPanel> createState() => _LoadedPanelState();
}

class _LoadedPanelState extends State<LoadedPanel> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    _scrollCtrl.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
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
      itemBuilder: (c, index) => RecordItem(
        onTap: () => widget.onSelectRecord(widget.state.records[index]),
        record: widget.state.records[index],
        active: widget.state.records[index].id == widget.state.activeRecordId,
      ),
    );
  }
}
