import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';

import 'loaded_record_v1.dart';
import 'loaded_record_v2.dart';
import 'record_edit_page.dart';

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
        actions: [Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
              splashRadius: 20,
              onPressed: ()=>_toAddPage(context), icon: Icon(Icons.add)),
        )],
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
      return PhoneLoadedPanelV2(
        state: state,
      );
      // return PhoneLoadedPanelV1(
      //   state: state,
      // );
    }
    return const SizedBox();
  }

  void _toAddPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>RecordEditPage()));

  }
}
