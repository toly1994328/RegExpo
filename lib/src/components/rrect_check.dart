import 'package:flutter/material.dart';

class RRectCheck extends StatelessWidget {
  final bool active;
  final double radius;
  final Color activeColor;
  final Color inActiveColor;

  const RRectCheck({
    Key? key,
    required this.active,
    this.radius = 6,
    this.activeColor = Colors.blue,
    this.inActiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return active ? buildChecked() : buildNotChecked();
  }

  Container buildChecked() {
    return Container(
      // margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(1.5),
      width: radius * 2.4,
      height: radius * 2.4,
      decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(2)),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 10,
      ),
    );
  }

  Container buildNotChecked() {
    return Container(
      // margin:const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(1.5),
      width: radius * 2.4,
      height: radius * 2.4,
      decoration: BoxDecoration(border: Border.all(color: inActiveColor, width: 1.5), borderRadius: BorderRadius.circular(2)),
    );
  }
}
