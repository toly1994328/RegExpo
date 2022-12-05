import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/views/desk_ui/record/loaded_panel.dart';
import 'package:regexpo/src/views/desk_ui/record/record_panel.dart';

import 'loaded_record.dart';
import 'phone_record_item.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;
    return Scaffold(

      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text("记录管理",style: TextStyle(color: titleColor,fontSize: 16),),
        elevation: 0,
      ),
      body: BlocBuilder<RecordBloc,RecordState>(
        builder: (_,state)=> _buildByState(state),
      ),
    );
  }


  Widget _buildByState(RecordState state) {
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
        // onRefresh: bloc.loadRecord,
      );
    }
    if (state is LoadedRecordState) {
      return PhoneLoadedPanel(
        state: state,
        // onSelectRecord: _selectRecord,
      );
    }
    return const SizedBox();
  }
}
