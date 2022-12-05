import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexpo/src/components/circle_image.dart';
import 'package:regexpo/src/components/logo.dart';

import 'page_item.dart';

/// create by 张风捷特烈 on 2020/4/26
/// contact me by email 1981462002@qq.com
/// 说明:

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color =Theme.of(context).dialogBackgroundColor;

    // AppStyle style = context.read<AppBloc>().state.appStyle;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value:const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light
          ),
          child: Column(
      children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/images/draw_bg3.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(
                      Icons.color_lens_outlined,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
              Positioned(
                bottom: 0,
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ColoredBox(
                  color: color,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 40,
                child: CircleImage(
                  size: 80,
                  shadowColor: Theme.of(context).primaryColor.withAlpha(33),
                  image: AssetImage('assets/images/icon_head_big.webp'),
                ),
              ),
              Positioned(
                  bottom: 5,
                  right: 30,
                  child: Text(
                    '张风捷特烈',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          const Expanded(child: MePageItem())
      ],
    ),
        ));
  }

}
