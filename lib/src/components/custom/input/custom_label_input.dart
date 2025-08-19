import 'package:flutter/material.dart';

class CustomIconInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final double height;
  final double fontSize;
  final ValueChanged<String>? onChanged;

  const CustomIconInput({
    super.key,
    this.controller,
    required this.icon,
    this.onChanged,
    this.hintText = "请输入...",
    this.height = 30,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = Theme.of(context).inputDecorationTheme.fillColor;

    return TextField(
      onChanged: onChanged,
      controller: controller,
      style: TextStyle(fontSize: fontSize),
      maxLines: 1,
      decoration: InputDecoration(
          filled: true,
          hoverColor: Colors.transparent,
          isCollapsed: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          fillColor: backgroundColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(icon, size: 18),
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 30, minHeight: 30),
          border: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: fontSize)),
    );
  }
}
