import 'package:flutter/material.dart';

import '../../navigation/model/nav_bean.dart';
import '../iconfont/toly_icon.dart';

class Cons {
  static NavItemList defaultNav = NavItemList(tabs: const [
    NavBean(
      name: 'Examples',
      icon: TolyIcon.icon_dir,
      id: 1,
    ),
    NavBean(
      name: 'Matches',
      icon: TolyIcon.icon_dot_all,
      id: 2,
    ),
    NavBean(
      name: 'Favorites',
      icon: Icons.security_rounded,
      id: 3,
      type: NavType.leftDown,
    ),
    NavBean(
        name: 'Input Panel',
        icon: TolyIcon.icon_input,
        id: 4,
        type: NavType.rightTop),
    NavBean(
        name: 'Recommend',
        icon: Icons.lightbulb_outline,
        id: 7,
        type: NavType.rightTop),
    NavBean(
        name: 'Help Me',
        icon: TolyIcon.icon_help,
        id: 6,
        type: NavType.rightDown),
    NavBean(
        name: 'NoteBook',
        icon: TolyIcon.icon_note,
        id: 5,
        type: NavType.rightTop),
  ]);
}
