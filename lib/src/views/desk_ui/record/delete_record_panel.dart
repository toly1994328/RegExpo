import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';

class DeleteRecordPanel extends StatelessWidget {
  final Record model;

  const DeleteRecordPanel({Key? key, required this.model}) : super(key: key);

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
          child: Text("数据删除后将无法恢复，是否确认删除标题为 [${model.title}] 记录！",style: TextStyle(fontSize: 15),),
        )
      ],
    );
  }

  Future<bool> _onConform(BuildContext context) async {
    RecordBloc bloc = context.read<RecordBloc>();
    return await bloc.deleteById(model.id);
  }
}
