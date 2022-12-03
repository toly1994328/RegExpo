import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/phone_ui/match/match_panel.dart';

class HomePopIcon extends StatelessWidget {
  final ValueChanged<File> onFileSelect;

  const HomePopIcon({
    super.key,
    required this.onFileSelect,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      splashRadius: 20,
      itemBuilder: _buildItem,
      onSelected: (v) => _onSelectItem(context, v),
      icon: const Icon(Icons.more_vert_outlined),
      position: PopupMenuPosition.under,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildItem(BuildContext context) {
    return [
      PopupMenuItem<String>(
        value: "open_file",
        child: Row(
          children: const [
            Icon(
              TolyIcon.icon_file,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "打开文件",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: "match",
        child: Row(
          children: const [
            Icon(
              TolyIcon.icon_dot_all,
              size: 22,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "匹配详情",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: "save",
        child: Row(
          children: const [
            Icon(TolyIcon.save),
            SizedBox(
              width: 7,
            ),
            Text(
              "保存正则",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: "theme",
        child: _ThemeSwitchMenuItem(),
      ),
    ];
  }

  void _onSelectItem(BuildContext context, String value) {
    if (value == 'theme') {
      context.read<AppConfigBloc>().switchThemeMode();
      return;
    }
    if (value == 'open_file') {
      onSelect();
      return;
    }
    if (value == 'match') {
      showMatchDialog(context);
      return;
    }
  }

  void showMatchDialog(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.618,
          child: PhoneMatchPanel(),
        ));
  }

  void onSelect() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.single;
      if (file.path != null && file.extension == ".txt") {
        onFileSelect(File(file.path!));
      }
    }
  }
}

class _ThemeSwitchMenuItem extends StatelessWidget {
  const _ThemeSwitchMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.select<AppConfigBloc, ThemeMode>(
      (value) => value.state.themeMode,
    );
    Widget icon = mode == ThemeMode.dark
        ? const Icon(TolyIcon.wb_sunny, size: 22)
        : const Icon(TolyIcon.dark, size: 22);
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        const Text(
          "暗亮切换",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
