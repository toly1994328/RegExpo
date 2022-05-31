import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../bloc/bloc_exp.dart';
import '../bloc/selection_cubic.dart';
import '../model/selection.dart';

class LeftNavContent extends StatelessWidget {
  const LeftNavContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, Selection>(builder: buildByState);
  }

  Widget buildByState(BuildContext context, Selection state) {
    if (state.activeLeftNavId == 0) {
      return const SizedBox.shrink();
    }
    NavBean activeNav = BlocProvider.of<NavCubit>(context)
        .state
        .tabs
        .singleWhere((element) => element.id == state.activeLeftNavId);

    Widget child = Text(activeNav.name);
    return DraggablePanel(
      left: true,
      child: child,
    );
  }
}

class RightNavContent extends StatelessWidget {

  const RightNavContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, Selection>(builder: buildByState);
  }

  Widget buildByState(BuildContext context, Selection state) {
    if (state.activeRightNavId == 0) {
      return const SizedBox.shrink();
    }
    NavBean activeNav = BlocProvider.of<NavCubit>(context)
        .state
        .tabs
        .singleWhere((element) => element.id == state.activeRightNavId);

    Widget child = Text(activeNav.name);
    return DraggablePanel(
      left: false,
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
  double width = 140;

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
