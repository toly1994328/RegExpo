import 'package:flutter/material.dart';

enum NavType{
  left,
  right,
}

class NavTab {
  final int id;
  final String name;
  final NavType type;
  final IconData icon;
  final bool down;

  const NavTab({
    required this.name,
    required this.icon,
    this.type = NavType.left,
    required this.id,
    this.down = false,
  });
}
