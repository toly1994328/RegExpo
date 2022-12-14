import 'package:flutter/material.dart';

class EmptyPanel extends StatelessWidget {
  final String data;
  final IconData icon;
  const EmptyPanel({super.key,required this.data,required this.icon});

  @override
  Widget build(BuildContext context) {

    Color color = const Color(0xffBCBCBC);
    return Center(
      child: Wrap(
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          Icon(icon,size: 56,color: color,),
          Text(data,style: TextStyle(color: color),),
        ],
      ),
    );
  }
}
