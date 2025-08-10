import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/blocs/blocs.dart';

class RecordCacheBar extends StatelessWidget {
  const RecordCacheBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Column(
      children: [
        Container(
          height: 26,
          color: color,
          child:Row(
            children: [
              Expanded(
                child: BlocBuilder<RecordBloc, RecordState>(
                  builder: _buildByState,
                ),
              ),
            ],
          ),
        ),
        Gap.dividerH,
      ],
    );
  }

  Widget _buildByState(BuildContext context, RecordState state) {
    Color color = Theme.of(context).brightness==Brightness.dark?const Color(0xff4E5254):Colors.white;
    final int activeTabId = state.active?.id??-1;
    return ListView(
        scrollDirection: Axis.horizontal,
        children: state.cacheRecord.asMap().keys.map((int index) {
          Record tab = state.cacheRecord[index];
          bool active = activeTabId == tab.id;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => activeTab(context, tab),
            child: Container(
              height: 25,
              color: active ? color : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_copy_outlined,
                        size: 13, color: Color(0xffBFC5C8)),
                    const SizedBox(width: 2),
                    Text(tab.title,
                        style: const TextStyle(height: 1, fontSize: 12)),
                    const SizedBox(width: 5),
                    GestureDetector(
                        onTap: () => removeCacheTab(context, tab,),
                            // deleteTab(context, tab, selection, index, state),
                        child: const Icon(Icons.close,
                            size: 13, color: Color(0xffBFC5C8))),
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }

  void activeTab(BuildContext context, Record record) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.selectCacheTab(record.id);
  }
  void removeCacheTab(BuildContext context, Record record) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.removeCacheTab(record.id);
  }

}


