import 'package:flutter/material.dart';

import '../../app/iconfont/toly_icon.dart';


class NavItemList {
  final List<NavBean> tabs;

  NavItemList({required this.tabs});

  List<NavBean> get leftNav => tabs
      .where((element) => element.isLeft)
      .toList();

  List<NavBean> get rightNav => tabs
      .where((element) =>element.isRight)
      .toList();

  static NavItemList defaultNav = NavItemList(tabs: const [
    NavBean(name: 'Examples', icon: TolyIcon.icon_dir, id: 1),
    NavBean(name: 'Matches', icon: TolyIcon.icon_dot_all, id: 2,),
    NavBean(name: 'Favorites', icon: Icons.security_rounded, id: 3,type: NavType.leftDown),
    NavBean(
        name: 'Input Panel',
        icon: TolyIcon.icon_input,
        id: 4,
        type: NavType.rightTop),
    NavBean(
        name: 'Help Me',
        icon: TolyIcon.icon_help,
        id: 6,
        type: NavType.rightTop),
    NavBean(
        name: 'NoteBook',
        icon: TolyIcon.icon_note,
        id: 5,
        type: NavType.rightTop),
  ]);
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
}
