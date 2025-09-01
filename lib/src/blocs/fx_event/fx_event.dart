import 'package:fx_trace/fx_trace.dart';

class RegexInputEvent extends InputEvent {
  final String symbol;

  RegexInputEvent(this.symbol);
}

class InputEvent extends FxEvent {
  InputEvent();
}

class FocusEvent extends InputEvent {
  FocusEvent();
}
