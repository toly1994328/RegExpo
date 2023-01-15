import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/components.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/models/task_result.dart';
import 'package:regexpo/src/utils/toast.dart';

class DeleteMessagePanel extends StatelessWidget {
  final Record model;

  const DeleteMessagePanel({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: const StadiumBorder(),
    );
    Color? cancelTextColor = Theme.of(context).textTheme.displayMedium?.color;
    return SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded,color: Colors.orange,),
            const SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("删除提示",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15,),
                    child: Text("数据删除后将无法恢复，是否确认删除标题为 [${model.title}] 记录！",style: TextStyle(fontSize: 14),),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      OutlinedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            // backgroundColor: Color(value),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: const StadiumBorder(),
                          ),
                          child:  Text(
                            '取消',
                            style:  TextStyle(fontSize: 12,color: cancelTextColor),
                          )),
                      const SizedBox(width: 10,),
                      AsyncButton(
                        style: style,
                        task: _doTask,
                        conformText: '删除',
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doTask(BuildContext context) async {
    RecordBloc bloc = context.read<RecordBloc>();
    TaskResult result = await bloc.deleteById(model.id);
    if (result.success) {
      Navigator.of(context).pop();
    } else {
      Toast.error(result.msg);
    }
  }
}
