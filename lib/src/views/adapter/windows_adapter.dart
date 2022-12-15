import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowsAdapter {

  static Future<void> setSize() async {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    //仅对桌面端进行尺寸设置
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        size: Size(900, 600),
        minimumSize: Size(900, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        // await windowManager.setAsFrameless();
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}