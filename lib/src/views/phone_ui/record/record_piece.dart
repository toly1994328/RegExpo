import 'package:flutter/material.dart';
import 'package:regexpo/src/models/models.dart';

class RecordPiece extends StatelessWidget {
  final Record record;

  const RecordPiece({Key? key,required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).scaffoldBackgroundColor;
    NavigationRailThemeData data = Theme.of(context).navigationRailTheme;
    TextStyle? title = data.unselectedLabelTextStyle;

    return Container(
        color: color,
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(record.title, style: title?.copyWith(fontSize: 14)),
            Text(
              record.content,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}