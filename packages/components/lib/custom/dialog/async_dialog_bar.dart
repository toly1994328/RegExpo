import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button/async_button.dart';

class AsyncDialogBar extends StatelessWidget {
  final String conformText;
  final Widget? leading;
  final String title;
  final AsyncTask onConform;
  final Color? color;

  const AsyncDialogBar({
    super.key,
    this.leading,
    this.conformText = "确定",
    this.color,
    this.title = "添加记录",
    required this.onConform,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: const StadiumBorder(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.close, size: 20)),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          AsyncButton(
            conformText: conformText,
            task: onConform,
            style: style,
          ),
        ],
      ),
    );
  }


}
