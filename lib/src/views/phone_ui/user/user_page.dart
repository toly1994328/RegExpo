import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexpo/src/components/toly_ui/circle_image.dart';
import 'package:regexpo/src/components/logo.dart';

import 'page_item.dart';

/// create by 张风捷特烈 on 2020/4/26
/// contact me by email 1981462002@qq.com
/// 说明:

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).dialogBackgroundColor;

    // AppStyle style = context.read<AppBloc>().state.appStyle;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'assets/images/draw_bg3.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned(
                  //   top: 50,
                  //   right: 20,
                  //   child: Container(
                  //       padding: const EdgeInsets.all(6),
                  //       decoration: BoxDecoration(
                  //           color: Colors.black.withOpacity(0.5),
                  //           borderRadius: BorderRadius.circular(4)),
                  //       child: const Icon(
                  //         Icons.color_lens_outlined,
                  //         color: Colors.white,
                  //         size: 20,
                  //       )),
                  // ),
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
                      image: AssetImage(
                          'ohos/entry/src/main/resources/base/media/logo.png'),
                    ),
                  ),
                  Positioned(
                      bottom: 6,
                      right: 30,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(
                            '正则通',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' V0.1.0',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ))
                ],
              ),
              const Expanded(child: MePageItem())
            ],
          ),
        ));
  }
}
