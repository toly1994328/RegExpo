import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/phone_ui/record/phone_record_item.dart';
import 'package:regexpo/src/views/splash/splash_page.dart';


class PhoneLoadedPanel extends StatefulWidget {
  final LoadedRecordState state;

  const PhoneLoadedPanel({
    super.key,
    required this.state,
  });

  @override
  State<PhoneLoadedPanel> createState() => _PhoneLoadedPanelState();
}

class _PhoneLoadedPanelState extends State<PhoneLoadedPanel> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
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
      itemBuilder: (c, index) {
        return PhoneRecordItem(
          key: Key(widget.state.records[index].id.toString()),
          record: widget.state.records[index],
        );
      },
    );
  }
}
