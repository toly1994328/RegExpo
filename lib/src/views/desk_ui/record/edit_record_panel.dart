import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';


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
        CustomDialogBar(
          title: widget.model == null ? "添加记录" : "修改记录",
          conformText: "确定",
          onConform: _onConform,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomIconInput(
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

  Future<bool> _onConform() async {
    if (!checkAllow()) return false;
    RecordBloc bloc = context.read<RecordBloc>();
    int result = -1;
    LoadType operation ;
    if (widget.model == null) {
      // 说明是添加
      operation = LoadType.add;
      result = await bloc.repository.insert(Record.i(
        title: titleCtrl.text,
        content: contentCtrl.text,
      ));

    } else {
      // 说明是修改
      operation = LoadType.edit;
      result = await bloc.repository.update(
        widget.model!.copyWith(
          title: titleCtrl.text,
          content: contentCtrl.text,
        ),
      );
    }
    if (result > 0) {
      bloc.loadRecord(operation: operation);
    } else {
      return false;
    }
    return true;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(msg),
        ),
      );
    }
    return msg.isEmpty;
  }
}
