import 'package:flutter/material.dart';
import 'package:regexpo/src/models/models.dart';

class RecordItem extends StatelessWidget {
  final Record record;
  final bool active;
  final VoidCallback onTap;

  const RecordItem({Key? key, required this.record, this.active = false,required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationRailThemeData data = Theme.of(context).navigationRailTheme;

    Color? color = data.backgroundColor;
    Color? activeColor = Theme.of(context).highlightColor;
    TextStyle? title = active?data.selectedLabelTextStyle:data.unselectedLabelTextStyle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          color: active
              ? activeColor
              : color,
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(record.title,style: title),
              Text(
                record.content,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
    );
  }
}