import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:regexpo/src/views/desk_ui/match/match_content.dart';

import 'match_top_bar.dart';

class PhoneMatchPanel extends StatelessWidget {
  const PhoneMatchPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(child: Column(
      children: const [
        PhoneMatchTopBar(),
        Gap.dividerH,
        Expanded(child: MatchContent()),
      ],
    ));
  }
}
