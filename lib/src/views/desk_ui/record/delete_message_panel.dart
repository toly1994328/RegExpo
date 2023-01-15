import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:components/components.dart';

class DeleteMessagePanel extends StatelessWidget {
  final String title;
  final String msg;
  final AsyncTask task;

  const DeleteMessagePanel({
    Key? key,
    required this.title,
    required this.msg,
    required this.task,
  }) : super(key: key);

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
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: Text(
                      msg,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            // backgroundColor: Color(value),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            '取消',
                            style:
                            TextStyle(fontSize: 12, color: cancelTextColor),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      AsyncButton(
                        conformText: '删除',
                        task: task,
                        style: style,
                      ),
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
}
