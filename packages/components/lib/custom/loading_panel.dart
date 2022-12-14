import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPanel extends StatelessWidget {
  final String data;

  const LoadingPanel({super.key, this.data="数据加载中"});

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xffBCBCBC);
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        direction: Axis.vertical,
        children: [
          const CupertinoActivityIndicator(),
          Text(data,style: TextStyle(color: color),),
        ],
      ),
    );
  }
}
