import 'dart:io';

import 'package:app_config/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/components.dart';

import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/desk_ui/splash/splash_page.dart';
import 'loaded_panel.dart';
import 'record_top_bar.dart';

class RecordPanel extends StatelessWidget{
  const RecordPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = BlocBuilder<RecordBloc,RecordState>(
      builder: _buildByState,
    );
    return PlatformUIAdapter(
      mobile: content,
      desk: Column(
        children: [
          const RecordTopBar(),
          Gap.dividerH,
          Expanded(child: content)
        ],
      ) ,
    );
  }

  void _selectRecord(BuildContext context,Record record) {
    context.read<RecordBloc>().select(record.id);
  }

  void _onRefresh(BuildContext context) {
    context.read<RecordBloc>().loadRecord();
  }

  Widget _buildByState(BuildContext context,RecordState state) {
    if (state is LoadingRecordState) {
      return const LoadingPanel();
    }
    if (state is EmptyRecordState) {
      return const EmptyPanel(
        data: "记录数据为空",
        icon: TolyIcon.icon_empty_panel,
      );
    }
    if (state is ErrorRecordState) {
      return ErrorPanel(
        data: "数据查询异常",
        icon: TolyIcon.zanwushuju,
        error: state.error,
        onRefresh: ()=>_onRefresh(context),
      );
    }
    if (state is LoadedRecordState) {
      return LoadedPanel(
        state: state,
        onSelectRecord: (record)=>_selectRecord(context,record),
      );
    }
    return const SizedBox();
  }

}
