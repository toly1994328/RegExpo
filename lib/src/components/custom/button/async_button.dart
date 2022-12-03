// import 'package:flutter/material.dart';
//
//
// typedef AsyncTask = Future<bool> Function();
//
// class AsyncButton extends StatefulWidget {
//   final AsyncTask task;
//   final VoidCallback onSuccess;
//   final VoidCallback onError;
//   final String conformText;
//
//   const AsyncButton({super.key,required this.task,required this.conformText});
//
//   @override
//   State<AsyncButton> createState() => _AsyncButtonState();
// }
//
// class _AsyncButtonState extends State<AsyncButton> {
//   bool _loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: _loading?null: _doTask,
//         style: ElevatedButton.styleFrom(
//             elevation: 0,
//             padding: EdgeInsets.zero,
//             shape: const StadiumBorder()),
//         child: Text(
//           widget.conformText,
//           style: const TextStyle(fontSize: 12),
//         ));
//   }
//
//   void _doTask() async{
//     _loading = true;
//     setState(() {
//
//     });
//     bool success = await widget.task();
//     if(success){
//       onError
//     }
//   }
// }
