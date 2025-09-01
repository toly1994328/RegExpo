import 'package:flutter/material.dart';

class RichTextEditingController extends TextEditingController {
  InlineSpan? _richTextSpan;

  set richTextSpan(InlineSpan? span) {
    _richTextSpan = span;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_richTextSpan != null) {
      final defaultStyle = (style ?? const TextStyle()).copyWith(color: Colors.black);
      return TextSpan(
        style: defaultStyle,
        children: [_richTextSpan!],
      );
    }
    return super.buildTextSpan(
      context: context,
      style: (style ?? const TextStyle()).copyWith(color: Colors.black),
      withComposing: withComposing,
    );
  }
}
