import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/views/desk_ui/record/edit_record_panel.dart';

class RecordEditPage extends StatelessWidget {
  final Record record;
  const RecordEditPage({super.key,required this.record});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text("修改记录",style: TextStyle(color: titleColor,fontSize: 16),),
        elevation: 0,
      ),
      body: _EditRecordPanel(model: record,),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(), elevation: 0),
                      onPressed: loading
                          ? null
                          : _onConform,
                      child: loading ? CupertinoActivityIndicator() : Text("确定")),
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
      Navigator.of(context).pop();
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