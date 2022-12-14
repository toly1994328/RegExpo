import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';
import 'package:regexpo/src/models/models.dart';


/// create by 张风捷特烈 on 2020-04-23
/// contact me by email 1981462002@qq.com
/// 说明:

class DeleteRegexPanel extends StatelessWidget {
  final LinkRegex model;

  const DeleteRegexPanel({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomDialogBar(
          leading: const Icon(Icons.warning_amber,color: Colors.redAccent,),
          color: Colors.redAccent,
          title: "删除提示",
          conformText: "确定",
          onConform: () => _onConform(context),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15,bottom: 30,left: 30,right: 35),
          child: Text("数据删除后将无法恢复，是否确认删除内容为 [${model.regex}] 的正则表达式！",style: TextStyle(fontSize: 15),),
        )
      ],
    );
  }

  Future<bool> _onConform(BuildContext context) async {
    LinkRegexBloc bloc = context.read<LinkRegexBloc>();
    Record? record = context.read<RecordBloc>().state.active;

    return await bloc.deleteById(model.id,record);

  }
}
