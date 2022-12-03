import 'package:flutter/material.dart';
import '../link_regex/link_regex_panel.dart';
import 'tool_panel.dart';

class RightNavContent extends StatefulWidget {
  final int activeIndex;
  final PageController controller;

  const RightNavContent({
    Key? key,
    this.activeIndex = 0,
    required this.controller,
  }) : super(key: key);

  @override
  State<RightNavContent> createState() => _RightNavContentState();
}

class _RightNavContentState extends State<RightNavContent> {


  double _width = 180;

  @override
  void initState() {
    print("======_LeftNavContentState#initState========");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).navigationRailTheme.backgroundColor;

    return Row(
      children: [
        if (widget.activeIndex != 0)
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: _changeWidth,
                child:
                const VerticalDivider(width: 2)),
          ),
        Container(
          alignment: Alignment.center,
          width: widget.activeIndex == 0 ? 0 : _width,
          color: color,
          child: _buildPageView(),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: widget.controller,
      children: [
        LinkRegexPanel(),
        // Center(child: Text("Link Regex")),
        ToolPanel(),
        Center(child: Text("Help Me")),
      ],
    );
  }

  void _changeWidth(DragUpdateDetails details) {
    setState(() {
      _width -= details.delta.dx;
    });
  }
}
