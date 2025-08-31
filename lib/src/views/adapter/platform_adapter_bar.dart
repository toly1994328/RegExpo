import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/style/app_theme_data.dart';

const double kMacosBarHeight = 28;

class PlatformAdapterBar extends StatelessWidget {
  final Widget child;
  final ThemeMode mode;

  const PlatformAdapterBar({
    super.key,
    required this.child,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      bool dark = mode == ThemeMode.dark;
      Color deskBarColor =
          dark ? const Color(0xff3C3F41) : const Color(0xffF2F2F2);
      Color? titleColor =
          dark ? const Color(0xffF2F2F2) : const Color(0xff3C3F41);
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Platform.isWindows || Platform.isLinux
                ? SizedBox(
                    height: kWindowCaptionHeight,
                    child: WindowCaption(
                      title: buildTitle(titleColor),
                      backgroundColor: deskBarColor,
                      brightness: dark ? Brightness.dark : Brightness.light,
                    ),
                  )
                : Container(
                    height: kMacosBarHeight,
                    color: deskBarColor,
                    child: NavigationToolbar(middle: buildTitle(titleColor)),
                  ),
            Expanded(child: child)
          ],
        ),
      );
    }
    return child;
  }

  Widget buildTitle(Color titleColor) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/regexpo_logo.png',
            width: 20,
            height: 20,
          ),
          Text(
            'RegExpo',
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
