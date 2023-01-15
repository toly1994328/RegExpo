import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/models/task_result.dart';
import 'package:regexpo/src/utils/toast.dart';

class RecordEditPage extends StatelessWidget {
  final Record? record;

  const RecordEditPage({super.key, this.record});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;
    String title = record == null ? "添加记录" : "修改记录";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text(
          title,
          style: TextStyle(color: titleColor, fontSize: 16),
        ),
        elevation: 0,
      ),
      body: _EditRecordPanel(
        model: record,
      ),
    );
  }
  //修改记录
}


class _EditRecordPanel extends StatefulWidget {
  final Record? model;

  const _EditRecordPanel({Key? key, this.model}) : super(key: key);

  @override
  _EditRecordPanelState createState() => _EditRecordPanelState();
}

class _EditRecordPanelState extends State<_EditRecordPanel> {

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
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
          child: CustomIconInput(
            controller: titleCtrl,
            height: 35,
            fontSize: 14,
            hintText: "输入记录名称...",
            icon: Icons.drive_file_rename_outline,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: CustomInputPanel(
              controller: contentCtrl,
              hintText: '输入记录内容...',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  onPressed: loading ? null : _onConform,
                  child: loading
                      ? const CupertinoActivityIndicator()
                      : const Text("确定")),
            ))
          ]),
        )
      ],
    );
  }

  bool loading = false;

  Future<void> _onConform() async {
    if (!checkAllow()) return;
    loading = true;
    setState(() {});
    RecordBloc bloc = context.read<RecordBloc>();
    TaskResult result;
    if (widget.model == null) { // 说明是添加
      result = await bloc.insert(titleCtrl.text, contentCtrl.text);
    } else { // 说明是修改
      result = await bloc.update(
        widget.model!.copyWith(
          title: titleCtrl.text,
          content: contentCtrl.text,
        ),
      );
    }
    if (result.success) {
      Navigator.of(context).pop();
    }else{
      Toast.error(result.msg);
    }
    loading = false;
    setState(() {});
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