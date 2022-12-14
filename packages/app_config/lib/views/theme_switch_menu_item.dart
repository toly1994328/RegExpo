import 'package:app_config/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_config.dart';

class ThemeSwitchMenuItem extends StatelessWidget {
  const ThemeSwitchMenuItem({super.key});

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
        const Text("暗亮切换"),
      ],
    );
  }
}