

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';

import '../../../models/models.dart';

class PhoneRegexInput extends StatefulWidget {
  const PhoneRegexInput({super.key});

  @override
  State<PhoneRegexInput> createState() => _PhoneRegexInputState();
}

class _PhoneRegexInputState extends State<PhoneRegexInput> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    LinkRegexState regex = context.read<LinkRegexBloc>().state;
    _listenLinkRegexChange(context, regex);
  }

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).inputDecorationTheme.fillColor;

    return BlocListener<LinkRegexBloc, LinkRegexState>(
      listener: _listenLinkRegexChange,
      child: SizedBox(
          height: 35,
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _ctrl,
              autofocus: false,
              enabled: true,
              cursorColor: Colors.blue,
              maxLines: 1,
              onChanged: (str) => _doSearch(context, str),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: color,
                  prefixIcon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(35 / 2)),
                  ),
                  hintText: "输入正则表达式...",
                  hintStyle: const TextStyle(fontSize: 14)),
            ),
          )),
    );
  }

  void _doSearch(BuildContext context, String str) {
    context.read<MatchBloc>().add(ChangeRegex(pattern: str));
  }

  void _listenLinkRegexChange(BuildContext context, LinkRegexState state) {
    if (state is LoadedLinkRegexState) {
      LinkRegex? regex = state.activeRegex;
      if (regex != null) {
        if (regex.id == -1) {
          _ctrl.text = '';
        } else {
          _ctrl.text = regex.regex;
        }
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}