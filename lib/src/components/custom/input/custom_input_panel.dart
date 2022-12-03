import 'package:flutter/material.dart';

class CustomInputPanel extends StatelessWidget {
  final TextEditingController controller;

  const CustomInputPanel({
    Key? key,
    required this.controller,
    this.color = Colors.lightBlue,
    this.minLines = 30,
    this.maxLines = 500,
    this.fontSize = 14,
    this.onChange,
    this.onSubmitted,
    this.hintText = "写点什么...",
  }) : super(key: key);

  final Color color; //字颜色
  final int minLines; //最小行数
  final int maxLines; //最大行数
  final double fontSize; //字号
  final String hintText; //提示字
  final ValueChanged<String>? onChange; //提交监听
  final ValueChanged<String>? onSubmitted; //提交监听

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = Theme.of(context).inputDecorationTheme.fillColor;

    // const Color backgroundColor = Colors.white;
    InputBorder border = UnderlineInputBorder(
      borderSide:  BorderSide(color: backgroundColor??Colors.transparent),
      borderRadius: BorderRadius.circular(5),
    );
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      textAlign: TextAlign.start,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        height: 1.2,
        // backgroundColor: Colors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        hoverColor: Colors.transparent,
        fillColor: backgroundColor,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize),
        focusedBorder: border,
        enabledBorder: border,
      ),
      onChanged: onChange,
      onSubmitted: onSubmitted,
    );
  }
}
