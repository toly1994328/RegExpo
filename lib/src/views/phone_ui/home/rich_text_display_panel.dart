import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/repositories/impl/db/helper/default_data.dart';
import 'package:regexpo/src/components/rich_text_editing_controller.dart';
import 'package:regexpo/src/models/models.dart';

import '../match/match_panel.dart';

class RichTextDisplayPanel extends StatefulWidget {
  const RichTextDisplayPanel({super.key});

  @override
  State<RichTextDisplayPanel> createState() => _RichTextDisplayPanelState();
}

class _RichTextDisplayPanelState extends State<RichTextDisplayPanel> {
  late RichTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RichTextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MatchBloc bloc = context.read<MatchBloc>();
    _controller.text = bloc.state.content;
    // bloc.style = Theme.of(context).textTheme.displayMedium;
    _controller.richTextSpan = bloc.state.inlineSpan();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MatchInfo? _findMatchAtPosition(List<MatchInfo> results, int position) {
    for (final match in results) {
      if (position >= match.startPos && position <= match.endPos) {
        return match;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.displayMedium;
    return BlocConsumer<MatchBloc, MatchState>(
      listener: (context, state) {
        if (_controller.text != state.content) {
          _controller.text = state.content;
        }
        _controller.richTextSpan = state.inlineSpan(style);
      },
      builder: (context, state) {
        if (state.content.isEmpty) {
          return const EmptyContent();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: TextField(
            controller: _controller,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            maxLines: null,
            style: style,
            // style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 50), () {
                final position = _controller.selection.baseOffset;
                if (state is MatchSuccess) {
                  final matchInfo =
                      _findMatchAtPosition(state.results, position);
                  if (matchInfo != null) {
                    context
                        .read<MatchBloc>()
                        .add(HoverMatchRegex(matchInfo: matchInfo));
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.618,
                              child: const PhoneMatchPanel(),
                            ));
                  }
                }
              });
            },
            onChanged: (content) {
              context.read<MatchBloc>().add(ChangeContent(content: content));
            },
          ),
        );
      },
    );
  }
}

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Image.asset('assets/images/regexpo_logo.png',
              width: 100, height: 100),
          const SizedBox(height: 16),
          const Text(
            "Welcome To Flutter RegExpo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xff6E6E6E)),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => insertTestData(context),
            child: const Text('导入测试数据'),
          ),
          const Spacer(),
          const Text(
            "Powered by 张风捷特烈 @2022",
            style: TextStyle(fontSize: 12, color: Color(0xff6E6E6E)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  static void insertTestData(BuildContext context) async {
    await DefaultData.insertDefaultRecoder();
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.loadRecord(operation: LoadType.refresh);
  }
}
