import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regexpo/src/components/components.dart';

class AsyncButton extends StatefulWidget {
  final AsyncTask task;
  final Color bgColor;
  final String text;
  final bool pop;

  const AsyncButton({
    super.key,
    required this.task,
    required this.bgColor,
    this.text = '确定',
    this.pop = true,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: widget.bgColor,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: const StadiumBorder());

    return ElevatedButton(
        onPressed: _loading ? null : _doTask,
        style: style,
        child: _loading
            ? const CupertinoActivityIndicator(radius: 8)
            : Text(
          widget.text,
          style: TextStyle(fontSize: 12),
        ));
  }

  bool _loading = false;

  void _doTask() async {
    _loading = true;
    setState(() {});
    bool success = await widget.task.call();
    if (success&&widget.pop) {
      Navigator.of(context).pop();
    }
    _loading = false;
    setState(() {});
  }
}