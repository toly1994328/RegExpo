import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/views/phone_ui/match/match_panel.dart';

class ClickableContentPanel extends StatefulWidget {
  const ClickableContentPanel({super.key});

  @override
  State<ClickableContentPanel> createState() => _ClickableContentPanelState();
}

class _ClickableContentPanelState extends State<ClickableContentPanel> {
  int? _activeMatchIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: BlocBuilder<MatchBloc, MatchState>(
              builder: (_, state) {
                if (state.content.isEmpty) {
                  return const EmptyContent();
                }
                return ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  children: [
                    _buildClickableText(context, state),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClickableText(BuildContext context, MatchState state) {
    if (state is! MatchSuccess) {
      return Text.rich(
        state.inlineSpan,
        style: Theme.of(context).textTheme.displayMedium,
      );
    }

    return Text.rich(
      _buildClickableSpan(context, state),
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  InlineSpan _buildClickableSpan(BuildContext context, MatchSuccess state) {
    if (state.span is! TextSpan) return state.span;
    
    TextSpan originalSpan = state.span as TextSpan;
    if (originalSpan.children == null) return originalSpan;

    List<InlineSpan> clickableChildren = [];
    int matchIndex = 0;
    
    for (InlineSpan child in originalSpan.children!) {
      if (child is TextSpan && child.style?.color != null) {
        // 这是高亮的匹配文本，添加点击功能和激活背景色
        final currentIndex = matchIndex;
        final isActive = _activeMatchIndex == currentIndex;
        
        clickableChildren.add(
          TextSpan(
            text: child.text,
            style: child.style?.copyWith(
              backgroundColor: isActive ? Colors.orange.withOpacity(0.3) : null,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _onMatchTap(context, currentIndex),
          ),
        );
        matchIndex++;
      } else {
        // 普通文本，保持原样
        clickableChildren.add(child);
      }
    }

    return TextSpan(children: clickableChildren);
  }

  void _onMatchTap(BuildContext context, int matchIndex) {
    setState(() {
      _activeMatchIndex = _activeMatchIndex == matchIndex ? null : matchIndex;
    });
    _showMatchDialog(context);
  }

  void _showMatchDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.618,
        child: const PhoneMatchPanel(),
      ),
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
          Image.asset('assets/images/regexpo_logo.png', width: 100, height: 100),
          const SizedBox(height: 16),
          const Text(
            "Welcome To Flutter RegExpo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xff6E6E6E)),
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
}