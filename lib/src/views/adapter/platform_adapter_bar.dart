import 'dart:io';

import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';

const double kDeskBarHeight = 32;
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
      final double height = Platform.isMacOS ? kMacosBarHeight : kDeskBarHeight;
      bool dark = mode == ThemeMode.dark;
      Color deskBarColor = dark ? AppThemeData.dark.backgroundColor : AppThemeData.light.backgroundColor;
      Color? titleColor = dark ? AppThemeData.light.backgroundColor : AppThemeData.dark.backgroundColor;
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Container(
              height: height,
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

  Widget buildTitle(Color titleColor) => Text(
    'RegExpo',
    style: TextStyle(
      color: titleColor,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );
}
