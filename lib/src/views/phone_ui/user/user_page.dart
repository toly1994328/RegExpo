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
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Image.asset(
                      'assets/images/draw_bg3.webp',
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
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ColoredBox(
                      color: color,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 40,
                    child: CircleImage(
                      size: 80,
                      shadowColor: Theme.of(context).primaryColor.withAlpha(33),
                      image: AssetImage('assets/images/icon_head_big.webp'),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      right: 30,
                      child: Text(
                        '张风捷特烈·出品',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                    "RegExpo 是一款基于 Flutter 构建的，全平台文本正则表达式交互匹配应用。可以帮助开发者可视化地感知，文本正则匹配结果，对文本处理、正则学习都大有帮助。\n\n源代码完全开放， Github：\nhttps://github.com/toly1994328/RegExp"),
              ))
              // const Expanded(child: MePageItem())
            ],
          ),
        ));
  }
}
