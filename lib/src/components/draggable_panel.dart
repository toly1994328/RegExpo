import 'package:flutter/material.dart';

class DraggablePanel extends StatefulWidget {
  final Widget child;
  final TextDirection direction;

  const DraggablePanel({Key? key, required this.child,  this.direction=TextDirection.ltr })
      : super(key: key);

  @override
  State<DraggablePanel> createState() => _DraggablePanelState();
}

class _DraggablePanelState extends State<DraggablePanel> {
  double width = 160;

  @override
  void initState() {
    super.initState();
    print("=====_DraggablePanelState#initState========");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.direction,
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
              child: VerticalDivider(width: 4, color: Color(0xffD1D1D1))),
        ),
      ],
    );
  }

  void _changeWidth(DragUpdateDetails details) {
    setState(() {
      if (widget.direction==TextDirection.ltr) {
        width += details.delta.dx;
      } else {
        width -= details.delta.dx;
      }
    });
  }
}