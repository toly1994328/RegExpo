import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';

import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/models/task_result.dart';
import 'package:regexpo/src/utils/toast.dart';

/// create by 张风捷特烈 on 2020-04-23
/// contact me by email 1981462002@qq.com
/// 说明:

class EditRegexPanel extends StatefulWidget {
  final LinkRegex? model;

  const EditRegexPanel({Key? key, this.model}) : super(key: key);

  @override
  _EditRegexPanelState createState() => _EditRegexPanelState();
}

class _EditRegexPanelState extends State<EditRegexPanel> {

  final TextEditingController contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentCtrl.text = widget.model?.regex ?? '';
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AsyncDialogBar(
          title: widget.model == null ? "添加关联正则" : "修改记录",
          conformText: "确定",
          onConform: _onConform,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomInputPanel(
              controller: contentCtrl,
              hintText: '输入正则表达式...',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Future<void> _onConform(BuildContext context) async {
    if (!checkAllow()) return;
    LinkRegexBloc bloc = context.read<LinkRegexBloc>();
    Record? record = context.read<RecordBloc>().state.active;
    if (record == null) return;
    TaskResult result;
    if (widget.model == null) {// 说明是添加
      result = await bloc.insert(contentCtrl.text, record.id);
    } else {// 说明是修改
      result = await bloc.update(
        widget.model!.copyWith(regex: contentCtrl.text),
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
