import 'package:flutter/material.dart';

class RRectCheck extends StatefulWidget {
  final bool value;
  final double radius;
  final Color activeColor;
  final Color inActiveColor;
  final void Function(bool value) onChanged;

  const RRectCheck({
    Key? key,
    required this.value,
    this.radius = 6,
    this.activeColor = Colors.blue,
    this.inActiveColor = Colors.grey,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RRectCheck> createState() => _RRectCheckState();
}

class _RRectCheckState extends State<RRectCheck> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _checked = !_checked;
        setState(() {});
        widget.onChanged(_checked);
      },
      child: _checked ? buildChecked() : buildNotChecked(),
    );
  }

  Container buildChecked() {
    return Container(
      // margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(1.5),
      width: widget.radius * 2.4,
      height: widget.radius * 2.4,
      decoration: BoxDecoration(color: widget.activeColor, borderRadius: BorderRadius.circular(2)),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 10,
      ),
    );
  }

  Container buildNotChecked() {
    return Container(
      // margin:const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(1.5),
      width: widget.radius * 2.4,
      height: widget.radius * 2.4,
      decoration: BoxDecoration(border: Border.all(color: widget.inActiveColor, width: 1.5), borderRadius: BorderRadius.circular(2)),
    );
  }
}
