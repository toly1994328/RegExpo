import 'package:flutter/material.dart';
class NavItemList {
  final List<NavBean> tabs;

  NavItemList({required this.tabs});

  List<NavBean> get leftNav => tabs
      .where((element) => element.isLeft)
      .toList();

  List<NavBean> get rightNav => tabs
      .where((element) =>element.isRight)
      .toList();
}

enum NavType {
  leftTop,
  leftDown,
  rightTop,
  rightDown,
}

class NavBean {
  final int id;
  final String name;
  final IconData icon;
  final NavType type;

  const NavBean({
    required this.name,
    required this.icon,
    required this.id,
    this.type = NavType.leftTop,
  });

  bool get isLeft => type == NavType.leftTop || type == NavType.leftDown;
  bool get isRight => type == NavType.rightTop || type == NavType.rightDown;

  NavBean copyWith({
    int? id,
    String? name,
    IconData? icon,
    NavType? type,
  }) {
    return NavBean(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
    );
  }
}
