import 'package:flutter/material.dart';
import 'toly_ui/feedback_widget.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeedbackWidget(
      onPressed: (){

      },
      child: const DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.blue)]),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/images/icon_head.webp'),
        ),
      ),
    );
  }
}