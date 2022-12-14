import 'package:flutter/material.dart';

class ErrorPanel extends StatelessWidget {
  final String data;
  final String? error;
  final IconData icon;
  final VoidCallback? onRefresh;

  const ErrorPanel({
    super.key,
    required this.data,
    required this.icon,
    this.error,
     this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xffDB5860);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: WrapCrossAlignment.center,
        // spacing: 10,
        // direction: Axis.vertical,
        children: [
          Spacer(),
          Icon(icon, size: 56, color: color),
          const SizedBox(height: 10,),
          Text(data, style: TextStyle(color: color)),
          const SizedBox(height: 5,),
          if(onRefresh!=null)
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder()
              ),
              onPressed: onRefresh, child: Text("刷新重试",style: TextStyle(fontSize: 12),)),
          Spacer(),
          if(error!=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("异常信息:\n$error",
                softWrap: true,
                style:
            TextStyle(color: color,fontSize: 10)),
          )
        ],
      ),
    );
  }
}
