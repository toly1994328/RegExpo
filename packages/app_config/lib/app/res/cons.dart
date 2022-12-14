import 'package:components/components.dart';
import 'package:flutter/material.dart';

import '../iconfont/toly_icon.dart';


class Cons {
  static List<NavTab> navTabs = const [
    NavTab(id: 1, name: 'Examples', icon: TolyIcon.icon_dir),
    NavTab(id: 2, name: 'Matches', icon: TolyIcon.icon_dot_all),
    NavTab(id: 3, name: 'Favorites', icon: Icons.star, down: true),
    NavTab(id: 4, type: NavType.right, name: 'Link Regex', icon: TolyIcon.icon_unicode),
    NavTab(id: 5, type: NavType.right, name: 'NoteBook', icon: TolyIcon.icon_note),
    NavTab(id: 6, type: NavType.right, name: 'Help Me', icon: TolyIcon.icon_help, down: true),
  ];
}
