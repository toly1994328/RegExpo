import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_tray/system_tray.dart';

import '../../blocs/blocs.dart';

class SystemTrayWrapper extends StatefulWidget {
  final Widget child;

  const SystemTrayWrapper({super.key, required this.child});

  @override
  State<SystemTrayWrapper> createState() => _SystemTrayWrapperState();
}

class _SystemTrayWrapperState extends State<SystemTrayWrapper> {
  late SystemTray systemTray;
  late AppWindow appWindow;

  @override
  void initState() {
    if(kIsWeb) return;
    if(Platform.isAndroid||Platform.isIOS) return;
    if (Platform.isWindows) {
      initWindowsSystemTray();
    } else {
      initMacosSystemTray();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  // create context menu
  final Menu menu = Menu();

  Future<void> initMacosSystemTray() async {
    String path = 'assets/images/regexpo_logo.png';
    appWindow = AppWindow();
    systemTray = SystemTray();
    await systemTray.initSystemTray(
      iconPath: path,
    );

    await buildMenu(menu);
    // set context menu
    await systemTray.setContextMenu(menu);
    systemTray.registerSystemTrayEventHandler(handleMacosTrayClick);
  }

  Future<void> buildMenu(Menu menu) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int mode = sp.getInt(SpKey.appThemeModel) ?? 0;
    await menu.buildFrom([
      SubMenu(label: '主题样式', children: [
        MenuItemCheckbox(
          label: '亮色模式',
          name: 'light',
          checked: mode == 0,
          onClicked: clickLightTheme,
        ),
        MenuItemCheckbox(
          label: '暗色模式',
          name: 'dark',
          checked: mode == 1,
          onClicked: clickDarkTheme,
        ),
      ]),
      MenuItemLabel(label: '显示应用', onClicked: show),
      MenuItemLabel(label: '隐藏应用', onClicked: hide),
      MenuItemLabel(label: '关闭应用', onClicked: close),
    ]);
  }

  void clickLightTheme(item) async {
    MenuItemCheckbox? lightBox = menu.findItemByName<MenuItemCheckbox>("light");
    // 亮色已选中，无事发生
    if (lightBox == null || lightBox.checked) return;

    await lightBox.setCheck(true);
    context.read<AppConfigBloc>().switchThemeMode();
    MenuItemCheckbox? darkBox = menu.findItemByName<MenuItemCheckbox>("dark");
    await darkBox?.setCheck(false);
  }

  void clickDarkTheme(item) async {
    MenuItemCheckbox? darkBox = menu.findItemByName<MenuItemCheckbox>("dark");
    // 暗色已选中，无事发生
    if (darkBox == null || darkBox.checked) return;
    await darkBox.setCheck(true);
    context.read<AppConfigBloc>().switchThemeMode();
    MenuItemCheckbox? lightBox = menu.findItemByName<MenuItemCheckbox>("light");
    await lightBox?.setCheck(false);
  }

  void show(item) {
    appWindow.show();
  }

  void hide(item) {
    appWindow.hide();
  }

  void close(item) {
    appWindow.close();
  }

  void handleMacosTrayClick(String eventName) {
    // 鼠标左键点击
    if (eventName == kSystemTrayEventClick) {
      systemTray.popUpContextMenu();
    }
    // 鼠标右键点击
    if (eventName == kSystemTrayEventRightClick) {
      appWindow.show();
    }
  }

  void handleWindowsTrayClick(String eventName) {
    // 鼠标左键点击
    if (eventName == kSystemTrayEventClick) {
      appWindow.show();
    }
    // 鼠标右键点击
    if (eventName == kSystemTrayEventRightClick) {
      systemTray.popUpContextMenu();
    }
  }

  Future<void> initWindowsSystemTray() async {
    String path = 'windows/runner/resources/app_icon.ico';
    appWindow = AppWindow();
    systemTray = SystemTray();
    await systemTray.initSystemTray(iconPath: path);

    await buildMenu(menu);
    await systemTray.setContextMenu(menu);
    systemTray.registerSystemTrayEventHandler(handleWindowsTrayClick);
  }
}
