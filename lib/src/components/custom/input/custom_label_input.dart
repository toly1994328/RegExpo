import 'package:flutter/material.dart';

class CustomIconInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;

  const CustomIconInput({
    super.key,
    this.controller,
    required this.icon,
    this.onChanged,
    this.hintText = "请输入...",
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = Theme.of(context).inputDecorationTheme.fillColor;

    return SizedBox(
      height: 30,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        style: const TextStyle(fontSize: 12),
        maxLines: 1,
        decoration:  InputDecoration(
            filled: true,
            hoverColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(top: 2),
            fillColor: backgroundColor,
            prefixIcon:  Icon(icon, size: 18),
            border: const UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
