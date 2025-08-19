import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/desk_ui/home/home_top_bar.dart';
import 'package:regexpo/src/views/phone_ui/link_regex/link_regex_tab.dart';

import 'home_pop_icon.dart';

class PhoneHomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PhoneHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;

    return AppBar(
      bottom: const LinkRegexTab(),
      titleSpacing: 0,
      backgroundColor: color,
      elevation: 0,
      title: RegexInput(
        height: 33,
        fontSize: 14,
        onRegexChange: (v) => _onRegexChange(context, v),
      ),
      actions: [
        // _ThemeToggleButton(),
        HomePopIcon(
          onFileSelect: (f) => _onFileSelect(context, f),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight + 26);
  }

  void _onRegexChange(BuildContext context, String value) {
    context.read<MatchBloc>().add(ChangeRegex(pattern: value));
  }

  void _onFileSelect(BuildContext context, File file) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.openFile(file);
  }
}

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.select<AppConfigBloc, ThemeMode>(
      (value) => value.state.themeMode,
    );
    Widget icon = mode == ThemeMode.dark
        ? const Icon(TolyIcon.wb_sunny, size: 22)
        : const Icon(TolyIcon.dark, size: 22);
    return IconButton(
      onPressed: () => context.read<AppConfigBloc>().switchThemeMode(),
      icon: icon,
    );
  }
}
