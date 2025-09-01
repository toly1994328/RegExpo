import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:file_picker_ohos/file_picker_ohos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fx_trace/fx_trace.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/toly_ui/feedback_widget.dart';
import 'package:regexpo/src/components/logo.dart';
import 'package:regexpo/src/models/models.dart';

import '../../../blocs/fx_event/fx_event.dart';

class HomeTopBar extends StatelessWidget {
  final ValueChanged<String> onRegexChange;
  final ValueChanged<File> onFileSelect;

  const HomeTopBar({
    Key? key,
    required this.onRegexChange,
    required this.onFileSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    return Container(
      height: 50,
      color: color,
      child: Row(children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 8.0, bottom: 8, right: 10),
          child: FeedbackWidget(
            onPressed: onSelect,
            child: const Icon(TolyIcon.icon_file, size: 22),
          ),
        ),
        const ThemeSwitchButton(),
        Expanded(
            child: RegexInput(
          onRegexChange: onRegexChange,
        )),
        const SaveRegexButton(),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 10),
          child: Logo(),
        ),
      ]),
    );
  }

  void onSelect() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        onFileSelect(File(path));
      }
    }
  }
}

class SaveRegexButton extends StatelessWidget {
  const SaveRegexButton({super.key});
  @override
  Widget build(BuildContext context) {
    bool emptyRegex = context.select<MatchBloc, bool>(
      (value) => value.state.pattern.isEmpty,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
      child: GestureDetector(
        onTap: emptyRegex ? null : () => _onSaveLinkRegex(context),
        child: Icon(
          TolyIcon.save,
          size: 24,
          color: emptyRegex ? Colors.grey : const Color(0xff59A869),
        ),
      ),
    );
  }

  void _onSaveLinkRegex(BuildContext context) async {
    String regex = context.read<MatchBloc>().state.pattern;
    Record? record = context.read<RecordBloc>().state.active;
    LinkRegexBloc linkRegexBloc = context.read<LinkRegexBloc>();
    if (record != null) {
      await linkRegexBloc.repository.insert(LinkRegex.i(
        recordId: record.id,
        regex: regex,
      ));
      linkRegexBloc.loadLinkRegex(recordId: record.id);
    }
  }
}

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.select<AppConfigBloc, ThemeMode>(
      (value) => value.state.themeMode,
    );
    Widget icon = mode == ThemeMode.dark
        ? const Icon(TolyIcon.wb_sunny, size: 22)
        : const Icon(TolyIcon.dark, size: 22);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 20, top: 8.0, bottom: 8),
      child: GestureDetector(
        onTap: () => _switchTheme(context),
        child: icon,
      ),
    );
  }

  void _switchTheme(BuildContext context) {
    context.read<AppConfigBloc>().switchThemeMode();
  }
}

class RegexInput extends StatefulWidget {
  final ValueChanged<String> onRegexChange;
  final double height;
  final double fontSize;

  const RegexInput({
    super.key,
    required this.onRegexChange,
    this.height = 28,
    this.fontSize = 12,
  });

  @override
  State<RegexInput> createState() => _RegexInputState();
}

class _RegexInputState extends State<RegexInput>
    with FxSingleEventMixin<RegexInput, InputEvent> {
  final TextEditingController _ctrl = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    LinkRegexState regex = context.read<LinkRegexBloc>().state;
    _focusNode.addListener(_onFocusChange);
    _listenLinkRegexChange(context, regex);
  }

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).inputDecorationTheme.fillColor;
    return BlocListener<LinkRegexBloc, LinkRegexState>(
      listener: _listenLinkRegexChange,
      child: SizedBox(
        height: widget.height,
        child: TextField(
          focusNode: _focusNode,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          controller: _ctrl,
          onChanged: widget.onRegexChange,
          style: TextStyle(fontSize: widget.fontSize),
          maxLines: 1,
          decoration: InputDecoration(
              filled: true,
              hoverColor: Colors.transparent,
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              fillColor: color,
              // prefixIcon: const Icon(Icons.edit, size: 18),
              border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              hintText: "输入正则表达式...",
              hintStyle: TextStyle(fontSize: widget.fontSize)),
        ),
      ),
    );
  }

  void _insertSymbol(String symbol) {
    final text = _ctrl.text;
    final selection = _ctrl.selection;
    
    String newText;
    int newOffset;
    
    if (symbol == '←') {
      if (selection.start > 0) {
        newText = text.replaceRange(selection.start - 1, selection.end, '');
        newOffset = selection.start - 1;
      } else {
        return;
      }
    } else {
      newText = text.replaceRange(selection.start, selection.end, symbol);
      newOffset = selection.start + symbol.length;
    }
    
    _ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    widget.onRegexChange(newText);
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
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void onEvent(InputEvent event) {
    if (event is RegexInputEvent) {
      _insertSymbol(event.symbol);
    }
    if (event is FocusEvent) {
      _focusNode.requestFocus();
    }
  }

  void _onFocusChange() {
    MatchBloc bloc = context.read<MatchBloc>();
    RegExpConfig cfg = bloc.state.config;
    cfg = cfg.copyWith(
      keyboardMode: _focusNode.hasFocus,
    );
    bloc.add(UpdateRegexConfig(config: cfg));
  }
}
