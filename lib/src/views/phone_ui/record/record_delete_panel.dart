import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/models/task_result.dart';

class PhoneDeleteRecord extends StatelessWidget {
  final Record model;

  const PhoneDeleteRecord({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 46,
            child: NavigationToolbar(
              trailing: CloseButton(),
              leading: Icon(
                Icons.warning_amber,
                color: Colors.redAccent,
                size: 20,
              ),
              middle: Text(
                '删除提示',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
            child: Text(
              "数据删除后将无法恢复，是否确认删除标题为 [${model.title}] 记录！",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              AsyncButton(
                conformText: "确定",
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.redAccent,
                    shape: const StadiumBorder()),
                task: (ctx) async {
                  RecordBloc bloc = context.read<RecordBloc>();
                  TaskResult result = await bloc.deleteById(model.id);
                  if (result.success) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}


