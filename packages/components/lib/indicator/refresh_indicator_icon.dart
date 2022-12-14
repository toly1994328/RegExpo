import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef VoidAsyncCallback = Future<void> Function();

class RefreshIndicatorIcon extends StatefulWidget {
  final VoidAsyncCallback onRefresh;
  final Duration? wait;

  const RefreshIndicatorIcon({super.key, required this.onRefresh, this.wait});

  @override
  State<RefreshIndicatorIcon> createState() => _RefreshIndicatorIconState();
}
enum TaskState{
  none,
  loading,
  done
}

class _RefreshIndicatorIconState extends State<RefreshIndicatorIcon> {
  @override
  Widget build(BuildContext context) {
    switch(_state){
      case TaskState.none:
        return GestureDetector(
          onTap: _doTask,
          child: const Icon(Icons.refresh, size: 16, color: Colors.grey),
        );
      case TaskState.loading:
        return const CupertinoActivityIndicator(radius: 8,);

      case TaskState.done:
        return const Icon(Icons.check, size: 16, color: Colors.green);
    }
  }

  TaskState _state = TaskState.none;

  void _doTask() async {
    _state = TaskState.loading;
    setState(() {});
    if (widget.wait != null) {
      await Future.delayed(widget.wait!);
    }
    await widget.onRefresh();
    _state = TaskState.done;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    _state = TaskState.none;
    setState(() {});
  }
}
