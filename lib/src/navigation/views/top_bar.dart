import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/components/logo.dart';
import 'package:regexpo/src/content/bloc/bloc.dart';
import 'package:regexpo/src/content/bloc/event.dart';
import 'package:regexpo/src/directory/bloc/bloc.dart';
import 'package:regexpo/src/directory/bloc/state.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';
import 'package:regexpo/src/navigation/bloc/bloc_exp.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xffF2F2F2),
      child: Row(children: const [
        SizedBox(width: 20),
        Expanded(flex: 3, child: RegexInput()),
        Spacer(flex: 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Logo(),
        )
      ]),
    );
  }

}

class RegexInput extends StatefulWidget {
  const RegexInput({Key? key}) : super(key: key);

  @override
  State<RegexInput> createState() => _RegexInputState();
}

class _RegexInputState extends State<RegexInput> {
  final TextEditingController regTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 28,
        child: BlocListener<SelectionCubit, UserSelection>(
          listenWhen: (p, n) => p.regex != n.regex,
          listener: _listenRegexChange,
          child: TextField(
            controller: regTextCtrl,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            onChanged: (str) => updateRegex(str),
            decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.only(top: 0),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, size: 18),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: "输入正则表达式...",
                hintStyle: TextStyle(fontSize: 12)),
          ),
        ));
  }

  void _listenRegexChange(BuildContext context, UserSelection state) {
    regTextCtrl.text = state.regex;
    updateRegex(state.regex);
  }

  void updateRegex(String regex) {
    int tabId = BlocProvider.of<SelectionCubit>(context).state.activeTabId;
    ExampleState exampleState = BlocProvider.of<ExampleBloc>(context).state;
    MatchBloc matchBloc = BlocProvider.of<MatchBloc>(context);
    if (exampleState is FullExampleState) {
      RegExample example = exampleState.data.firstWhere((element) => element.id == tabId);
      matchBloc.add(MatchRegex(content: example.content, regex: regex));
    }
  }
}
