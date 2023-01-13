
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/style/app_theme_data.dart';
import 'package:regexpo/src/blocs/bloc_wrapper.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/adapter/system_tray_wrapper.dart';
import 'src/blocs/bloc_relation.dart';

import 'src/views/adapter/platform_adapter_bar.dart';
import 'src/views/desk_ui/splash/splash_page.dart';

void main() {
  runApp( BlocWrapper(child: const SystemTrayWrapper(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.select<AppConfigBloc, ThemeMode>(
          (value) => value.state.themeMode,
    );
    return BlocRelation(
      child: MaterialApp(
        title: 'regexpo',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: AppThemeData.light,
        darkTheme:  AppThemeData.dark,
        home: const SplashPage(),
      ),
    );
  }
}
