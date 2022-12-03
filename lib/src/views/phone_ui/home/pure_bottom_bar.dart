import 'package:flutter/material.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';


class PureBottomBar extends StatefulWidget {
  final int initPosition;

  // item 点击事件
  final ValueChanged<int>? onItemTap;

  // item 长按事件
  final ValueChanged<int>? onItemLongTap;
  const PureBottomBar({Key? key, this.onItemTap,this.onItemLongTap,this.initPosition=0}) : super(key: key);

  @override
  State<PureBottomBar> createState() => _PureBottomBarState();
}

class _PureBottomBarState extends State<PureBottomBar> {
  List<String> get bottomBar => const['匹配','记录', '手记','我的'];

  List<IconData> get bottomBarIcon => const[
    TolyIcon.icon_dot_all,
    TolyIcon.icon_dir,
    TolyIcon.icon_note,
    Icons.account_circle,
  ];
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.initPosition;
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    return Wrap(
      children: [
        // Divider(height: 1,),
        BottomNavigationBar(
          backgroundColor: color,
          onTap: (position) {
            // checkTokenExpires();
            _position = position;

            widget.onItemTap?.call(_position);
            setState(() {

              // _controller.jumpToPage(_position);
            });
          },
          currentIndex: _position,

          elevation: 3,
          // fixedColor: themeColor.activeColor,
          type: BottomNavigationBarType.fixed,
          iconSize: 22,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: true,
          showSelectedLabels: true,
          // backgroundColor: themeColor.itemColor,
          items: bottomBar.asMap().keys.map((index) => BottomNavigationBarItem(label: bottomBar[index], icon: Icon(bottomBarIcon[index]))).toList(),
        ),
      ],
    );
  }
}
