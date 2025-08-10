import 'package:flutter/material.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';


class HomeBottomBar extends StatefulWidget {
  final int initIndex;

  final ValueChanged<int> onTap;

  const HomeBottomBar({Key? key, required this.onTap, this.initIndex = 0})
      : super(key: key);

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

const Map<String, IconData> kBottomBarMap = {
  '匹配': TolyIcon.icon_dot_all,
  '记录': TolyIcon.icon_dir,
  '手记': TolyIcon.icon_note,
  '我的': Icons.account_circle,
};

class _HomeBottomBarState extends State<HomeBottomBar> {
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.initIndex;
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return BottomNavigationBar(
      backgroundColor: color,
      onTap: _onTap,
      currentIndex: _position,
      elevation: 3,
      type: BottomNavigationBarType.fixed,
      iconSize: 22,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: _buildItems(),
    );
  }

  void _onTap(int position) {
    _position = position;
    widget.onTap(_position);
    setState(() {});
  }

  List<BottomNavigationBarItem> _buildItems() => kBottomBarMap.keys
      .map(
        (String key) => BottomNavigationBarItem(
          label: key,
          icon: Icon(kBottomBarMap[key]),
        ),
      ).toList();
}
