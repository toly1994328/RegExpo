import 'package:flutter/material.dart';

import '../model/nav_tab.dart';
import 'nav_tab_item.dart';

class RailTabNavigation extends StatelessWidget {
  final double width;
  final int activeId;
  final List<NavTab> items;
  final TextDirection? textDirection;
  final ValueChanged<NavTab> onSelect;

  const RailTabNavigation({
    Key? key,
    this.width = 22,
    required this.activeId,
    required this.onSelect,
    this.textDirection,
    required this.items,
  }) : super(key: key);

  Iterable<NavTab> get upTabs => items.where((e) => e.down == false);
  Iterable<NavTab> get downTabs => items.where((e) => e.down == true);

  @override
  Widget build(BuildContext context) {
    ThemeData data = Theme.of(context);
    Color color = data.backgroundColor;
    return Row(
      textDirection: textDirection,
      children: [
        Container(
          color: color,
          width: width,
          child: Column(
            children: [
              ...buildNavByType(upTabs),
              const Spacer(),
              ...buildNavByType(downTabs),
            ],
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
      ],
    );
  }

  Iterable<Widget> buildNavByType(Iterable<NavTab> tabs) {
    return tabs.map((NavTab tab) => NavTabItem(
textDirection: textDirection,
    active: activeId == tab.id,
          navTab: tab,
          onTap: onSelect,
        ));
  }
}

