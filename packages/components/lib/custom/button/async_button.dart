import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef AsyncTask = Future<void> Function(BuildContext context);

class AsyncButton extends StatefulWidget {
  final ButtonStyle? style;
  final AsyncTask task;
  final String conformText;

  const AsyncButton({
    super.key,
    required this.task,
    this.style,
    required this.conformText,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _loading ? null : _doTask,
        style: widget.style??ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: const StadiumBorder()),
        child: _loading
            ? const CupertinoActivityIndicator(radius: 8)
            :Text(
          widget.conformText,
          style: const TextStyle(fontSize: 12),
        ));
  }

  void _doTask() async {
    setState(() {
      _loading = true;
    });
    await widget.task(context);
    setState(() {
      _loading = false;
    });
  }
}
