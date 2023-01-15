import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/utils/toast.dart';

import '../../../models/task_result.dart';


class EditRecordPanel extends StatefulWidget {
  final Record? model;

  const EditRecordPanel({Key? key, this.model}) : super(key: key);

  @override
  _EditRecordPanelState createState() => _EditRecordPanelState();
}

class _EditRecordPanelState extends State<EditRecordPanel> {

  final TextEditingController contentCtrl = TextEditingController();
  final TextEditingController titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentCtrl.text = widget.model?.content ?? '';
    titleCtrl.text = widget.model?.title ?? '';
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AsyncDialogBar(
          title: widget.model == null ? "添加记录" : "修改记录",
          conformText: "确定",
          onConform: _onConform,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomIconInput(
            fontSize: 14,
            height: 32,
            controller: titleCtrl,
            hintText: "输入记录名称...",
            icon: Icons.drive_file_rename_outline,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: CustomInputPanel(
              controller: contentCtrl,
              hintText: '输入记录内容...',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onConform(BuildContext context) async {
    if (!checkAllow()) return ;
    RecordBloc bloc = context.read<RecordBloc>();
    TaskResult result;
    if (widget.model == null) {
      // 说明是添加
      result = await bloc.insert(titleCtrl.text, contentCtrl.text);
    } else {
      // 说明是修改
      result = await bloc.update(
        widget.model!.copyWith(
          title: titleCtrl.text,
          content: contentCtrl.text,
        ),
      );
    }
    if(result.success){
      Navigator.of(context).pop();
    }else{
      Toast.error(result.msg);
    }
  }

  bool checkAllow() {
    String msg = '';
    if (titleCtrl.text.isEmpty) {
      msg = "标题不能为空!";
    }
    if (contentCtrl.text.isEmpty) {
      msg = "内容不能为空!";
    }
    if (msg.isNotEmpty) {
      Toast.warning(msg);
    }
    return msg.isEmpty;
  }
}
