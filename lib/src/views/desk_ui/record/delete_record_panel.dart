import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';

class DeleteMessagePanel extends StatefulWidget {
  final Record model;

  const DeleteMessagePanel({Key? key, required this.model}) : super(key: key);

  @override
  State<DeleteMessagePanel> createState() => _DeleteMessagePanelState();
}

class _DeleteMessagePanelState extends State<DeleteMessagePanel> {

  bool _loading = false;

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
                    child: Text("数据删除后将无法恢复，是否确认删除标题为 [${widget.model.title}] 记录！",style: TextStyle(fontSize: 14),),
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
                      ElevatedButton(
                          onPressed: _loading ? null : _doTask,
                          style: style,
                          child: _loading
                              ? const CupertinoActivityIndicator(radius: 8)
                              : Text(
                            '删除',
                            style: const TextStyle(fontSize: 12),
                          )),
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

  void _doTask() async{
    RecordBloc bloc = context.read<RecordBloc>();
    await bloc.deleteById(widget.model.id);
    Navigator.of(context).pop();
  }
}
