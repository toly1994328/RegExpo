import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 1, color: Colors.blue)]),
          // padding: EdgeInsets.all(1),
          child: CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('assets/images/icon_head.webp'),
          ),
        ),
        // FlutterLogo(
        //   size: 35,
        // ),

      ],
    );
  }
}
