import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_exp.dart';

class NavBar extends StatelessWidget {
  final double width;
  final bool left;

  const NavBar({Key? key, this.width = 22, this.left = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, NavItemList>(
      builder: (_, navList) => BlocBuilder<SelectionCubit, UserSelection>(
          buildWhen: (p, n) =>
          p.activeLeftNavId != n.activeLeftNavId ||
              p.activeRightNavId != n.activeRightNavId,
          builder: (ctx, selection) =>
              buildByState(context, navList, selection)),
    );
  }

  void _onTapIndex(BuildContext context, NavBean navBean) {
    SelectionCubit cubit = BlocProvider.of<SelectionCubit>(context);
    cubit.selectNav(navBean);
  }

  Widget buildByState(BuildContext context, NavItemList navList, UserSelection state) {
    return DragTarget<NavBean>(
      onWillAccept: _onWillAccept,
      onAcceptWithDetails: (detail) => _onAcceptWithDetails(context, detail, state),
      builder: (BuildContext context, List<NavBean?> candidateData,
          List<dynamic> rejectedData,) {
        return Container(
          width: width,
          color: const Color(0xffF2F2F2),
          child: Column(
            children: [
              if (left)...buildNavByType(navList.leftNav, NavType.leftTop, state),
              if (!left)...buildNavByType(navList.rightNav, NavType.rightTop, state),
              const Spacer(),
              if (left)...buildNavByType(navList.leftNav, NavType.leftDown, state),
              if (!left)...buildNavByType(navList.rightNav, NavType.rightDown, state),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildNavByType(
      List<NavBean> items,
      NavType type,
      UserSelection selection,
      ) {
    final int activeLeftNavId = selection.activeLeftNavId;
    final int activeRightNavId = selection.activeRightNavId;

    List<NavBean> beans = items.where((e) => e.type == type).toList();
    return beans.asMap().keys.map((int index) {
      NavBean navBean = beans[index];
      bool active = activeLeftNavId == navBean.id || activeRightNavId == navBean.id;
      Widget child = NavBarItem(
        active: active,
        navBean: navBean,
        onTap: _onTapIndex,
      );
      return Draggable<NavBean>(
          data: navBean,
          feedback: Material(
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
          child: child);
    }).toList();
  }

  bool _onWillAccept(NavBean? data) {
    return data != null;
  }

  void _onAcceptWithDetails(BuildContext context,
      DragTargetDetails<NavBean> details, UserSelection state) {
    late NavType type;
    Size winSize = MediaQuery.of(context).size;
    if (details.offset.dx > winSize.width / 2 &&
        details.offset.dy < winSize.height / 2) {
      type = NavType.rightTop;
    }
    if (details.offset.dx < winSize.width / 2 &&
        details.offset.dy < winSize.height / 2) {
      type = NavType.leftTop;
    }
    if (details.offset.dx < winSize.width / 2 &&
        details.offset.dy > winSize.height / 2) {
      type = NavType.leftDown;
    }
    if (details.offset.dx > winSize.width / 2 &&
        details.offset.dy > winSize.height / 2) {
      type = NavType.rightDown;
    }

    SelectionCubit selectionCubit = BlocProvider.of<SelectionCubit>(context);
    selectionCubit.handleDragNavTab(details.data, type);

    BlocProvider.of<NavCubit>(context).swap(details.data, type);
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
    Color? itemColor = active ? const Color(0xffBDBDBD) : null;
    const Color iconColor = Color(0xff6E6E6E);
    const TextStyle style = TextStyle(height: 1, fontSize: 11);
    const EdgeInsets padding = EdgeInsets.only(left: 8, right: 8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap.call(context, navBean),
      child: Container(
        width: width,
        color: itemColor,
        child: RotatedBox(
          quarterTurns: quarterTurns,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: iconQuarterTurns,
                  child: Icon(navBean.icon, size: 13, color: iconColor),
                ),
                const SizedBox(width: 5),
                Text(navBean.name, style: style,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
