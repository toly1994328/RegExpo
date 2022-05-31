import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_exp.dart';

class NavBar extends StatelessWidget {
  final double width;
  final List<NavBean> items;

  const NavBar({Key? key, this.width = 22, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, Selection>(
        buildWhen: (p, n) =>
            p.activeLeftNavId != n.activeLeftNavId ||
            p.activeRightNavId != n.activeRightNavId,
        builder: buildByState);
  }

  void _onTapIndex(BuildContext context, NavBean navBean) {
    SelectionCubit cubit = BlocProvider.of<SelectionCubit>(context);
    cubit.selectNav(navBean);
  }

  Widget buildByState(BuildContext context, Selection state) {
    return Container(
      width: width,
      color: const Color(0xffF2F2F2),
      child: Column(
        children: [
          ...buildNavByType(NavType.leftTop, state),
          ...buildNavByType(NavType.rightTop, state),
          const Spacer(),
          ...buildNavByType(NavType.leftDown, state),
          ...buildNavByType(NavType.rightDown, state),
        ],
      ),
    );
  }

  List<Widget> buildNavByType(NavType type, Selection selection) {
    final int activeLeftNavId = selection.activeLeftNavId;
    final int activeRightNavId = selection.activeRightNavId;

    List<NavBean> beans =
        items.where((element) => element.type == type).toList();
    return beans.asMap().keys.map((int index) {
      NavBean navBean = beans[index];
      bool active =
          activeLeftNavId == navBean.id || activeRightNavId == navBean.id;

      return NavBarItem(
        active: active,
        navBean: navBean,
        onTap: _onTapIndex,
      );
    }).toList();
  }
}

class NavBarItem extends StatelessWidget {
  final double width;
  final NavBean navBean;
  final bool active;
  final Function(BuildContext context, NavBean navBean) onTap;

  const NavBarItem({
    Key? key,
    this.width = 22,
    required this.navBean,
    this.active = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quarterTurns = navBean.isLeft ? 3 : 1;
    int iconQuarterTurns = navBean.isLeft ? 1 : 3;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap.call(context, navBean),
      child: Container(
        width: width,
        color: active ? const Color(0xffBDBDBD) : null,
        child: RotatedBox(
          quarterTurns: quarterTurns,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                    quarterTurns: iconQuarterTurns,
                    child: Icon(
                      navBean.icon,
                      size: 13,
                      color: Color(0xff6E6E6E),
                    )),
                const SizedBox(width: 5),
                Text(
                  navBean.name,
                  style: const TextStyle(height: 1, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
