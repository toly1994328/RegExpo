import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/navigation/views/nav_content_factory.dart';

import '../bloc/bloc_exp.dart';

class NavContent extends StatelessWidget {
  final bool left;

  const NavContent({Key? key, required this.left}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, UserSelection>(builder: buildByState);
  }

  Widget buildByState(BuildContext context, UserSelection state) {
    int id = left ? state.activeLeftNavId : state.activeRightNavId;
    Widget child = NavContentFactory.getContentById(id);
    if (id == 0) {
      return child;
    }

    return DraggablePanel(
      left: left,
      child: child,
    );
  }
}


class DraggablePanel extends StatefulWidget {
  final Widget child;
  final bool left;

  const DraggablePanel({Key? key, required this.child, required this.left})
      : super(key: key);

  @override
  State<DraggablePanel> createState() => _DraggablePanelState();
}

class _DraggablePanelState extends State<DraggablePanel> {
  double width = 200;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.left ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Container(
          alignment: Alignment.center,
          width: width,
          color: Colors.white,
          child: widget.child,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: _changeWidth,
              child: const VerticalDivider(width: 2, color: Color(0xffD1D1D1))),
        ),
      ],
    );
  }

  void _changeWidth(DragUpdateDetails details) {
    setState(() {
      if (widget.left) {
        width += details.delta.dx;
      } else {
        width -= details.delta.dx;
      }
    });
  }
}
