import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/models/task_result.dart';
import 'package:regexpo/src/utils/toast.dart';

import 'delete_message_panel.dart';
import 'edit_record_panel.dart';

class RecordTopBar extends StatelessWidget {
  const RecordTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Container(
      height: 26,
      padding: const EdgeInsets.only(left: 8, right: 4),
      alignment: Alignment.centerLeft,
      color: color,
      child: Row(
        children: [
          const Text(
            '选择记录',
            style: TextStyle(fontSize: 11),
          ),
          const SizedBox(width: 4,),
          RefreshIndicatorIcon(
            wait: Duration(seconds: 1),
            onRefresh: ()=>_onRefresh(context),
          ),
          const Spacer(),
          Wrap(
            spacing: 4,
            children: [
              GestureDetector(
                onTap: () => showEditeDialog(context),
                child: const Icon(
                  TolyIcon.icon_edit,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              GestureDetector(
                onLongPress: () => showDeleteAllDialog(context),
                onTap: () => showDeleteDialog(context),
                child: const Icon(TolyIcon.icon_delete,
                    size: 16, color: Colors.redAccent),
              ),

              GestureDetector(
                  onTap: () => showAddDialog(context),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xff7E7E7E),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 5),
              child:  Dialog(
                backgroundColor: color,
                child: EditRecordPanel(),
              ),
            ));
  }

  void showEditeDialog(BuildContext context) {
    RecordBloc bloc = context.read<RecordBloc>();
    Color color = Theme.of(context).colorScheme.surface;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5),
          child:  Dialog(
            backgroundColor: color,
            child: EditRecordPanel(model: bloc.state.active,),
          ),
        ));
  }

  void showDeleteDialog(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;

    RecordBloc bloc = context.read<RecordBloc>();
    Record? record = bloc.state.active;
    if(record == null) return;
    String msg = "数据删除后将无法恢复，是否确认删除标题为 [${record.title}] 记录！";

    showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: color,
          child: DeleteMessagePanel(
            title: '删除提示',
            msg: msg,
            task: _doDeleteTask,
          ),
        ));
  }

  Future<void> _doDeleteTask(BuildContext context) async {
    RecordBloc bloc = context.read<RecordBloc>();
    Record record = bloc.state.active!;
    TaskResult result = await bloc.deleteById(record.id);
    if (result.success) {
      Navigator.of(context).pop();
    } else {
      Toast.error('删除异常!');
    }
  }

  void showDeleteAllDialog(BuildContext context) {
    RecordBloc bloc = context.read<RecordBloc>();
    Record? record = bloc.state.active;
    if (record == null) return;
    showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: const Color(0xffF2F2F2),
          child: DeleteMessagePanel(
            title: '删除提示',
            msg: '数据删除后将无法恢复，是否确认删除所有记录数据！',
            task: _doDeleteAllTask,
          ),
        ));
  }

  Future<void> _doDeleteAllTask(BuildContext context) async {
    RecordBloc bloc = context.read<RecordBloc>();
    TaskResult result = await bloc.deleteAll();
    if (result.success) {
      Navigator.of(context).pop();
    } else {
      Toast.error('删除异常!');
    }
  }

  void refresh(BuildContext context) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.loadRecord(operation: LoadType.refresh);
  }

  Future<void> _onRefresh(BuildContext context) async{
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.loadRecord(operation: LoadType.refresh);
  }
}
