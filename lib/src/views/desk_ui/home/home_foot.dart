import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';

class FootBar extends StatelessWidget {
  const FootBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Container(
      height: 20,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Row(
        children: const[
          RegexConfigTools(),
          Spacer(),
          ResultShower(),
        ],
      ),
    );
  }
}

class ResultShower extends StatelessWidget {
  const ResultShower({Key? key}) : super(key: key);


  final TextStyle errorStyle = const TextStyle(fontSize: 11, color: Colors.red);
  final TextStyle style = const TextStyle(fontSize: 11, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
        builder: buildInfoByState);
  }

  Widget buildInfoByState(BuildContext context, MatchState state) {
    if (state is MatchError) {
      return Text(
        state.error,
        style: errorStyle,
      );
    }
    if (state is MatchSuccess) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          Text(
            '规则正常',
            style: style,
          ),
          Text(
            'match: ${state.matchCount}',
            style: style,
          ),
          Text(
            'group: ${state.groupCount}',
            style: style,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}


class RegexConfigTools extends StatelessWidget {
  final double fontSize;
  const RegexConfigTools({
    Key? key,
    this.fontSize = 11
  }) : super(key: key);

  final List<String> configInfo = const [
    'multiLine',
    'caseSensitive',
    'dotAll',
    'unicode',
  ];

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    RegExpConfig config = context.select<MatchBloc, RegExpConfig>(
      (value) => value.state.config,
    );
    TextStyle style = TextStyle(
      fontSize: fontSize,
      color: Colors.grey.withOpacity(0.8),
      height: 1,
    );
    TextStyle activeStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      height: 1,
    );

    return Wrap(
      children: configInfo.asMap().keys.map((int index) {
        bool active = checkActive(config, index);
        return GestureDetector(
          onTap: () => _onSelect(context, index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
            child: Text(
              configInfo[index],
              style: active ? activeStyle : style,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onSelect(BuildContext context, int index) {
    MatchBloc bloc = context.read<MatchBloc>();
    RegExpConfig cfg = bloc.state.config;
    cfg = cfg.copyWith(
      multiLine: index == 0 ? !cfg.multiLine : null,
      caseSensitive: index == 1 ? !cfg.caseSensitive : null,
      dotAll: index == 2 ? !cfg.dotAll : null,
      unicode: index == 3 ? !cfg.unicode : null,
    );
    bloc.add(UpdateRegexConfig(config: cfg));
  }

  bool checkActive(RegExpConfig config, index) {
    if (index == 0) {
      return config.multiLine;
    }
    if (index == 1) {
      return config.caseSensitive;
    }
    if (index == 2) {
      return config.dotAll;
    }
    if (index == 3) {
      return config.unicode;
    }
    return false;
  }
}
