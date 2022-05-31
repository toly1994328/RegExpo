import 'package:flutter/material.dart';

class FootBar extends StatelessWidget {
  const FootBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: const Color(0xffF2F2F2),
      child: Row(
        children: const[
           Spacer(),
           Text('规则正常',style: TextStyle(fontSize: 11),),
          SizedBox(width: 5,),
          Text('match:224',style: TextStyle(fontSize: 11),),
          SizedBox(width: 25,)
        ],
      ),
    );
  }
}
