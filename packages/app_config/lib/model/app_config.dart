import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const Map<int, ThemeMode> kAppThemeMap = {
  0: ThemeMode.light,
  1: ThemeMode.dark,
};

class AppConfig extends Equatable {
  /// 关联关系见 [kAppThemeMap]
  final int appThemeMode;
  final bool inited;

  const AppConfig({this.appThemeMode = 0, this.inited = false});

  ThemeMode get themeMode => kAppThemeMap[appThemeMode]!;

  AppConfig copyWith({
    int? appThemeMode,
    bool? inited,
  }) {
    return AppConfig(
      appThemeMode: appThemeMode ?? this.appThemeMode,
      inited: inited ?? this.inited,
    );
  }

  @override
  List<Object?> get props => [appThemeMode,inited];
}
