import 'package:equatable/equatable.dart';

class RegExpConfig extends Equatable {
  final bool multiLine;
  final bool caseSensitive;
  final bool unicode;
  final bool dotAll;
  final bool replaceMode;
  final bool keyboardMode;

  const RegExpConfig({
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
    this.replaceMode = false,
    this.keyboardMode = false,
  });

  RegExpConfig copyWith({
    bool? multiLine,
    bool? caseSensitive,
    bool? unicode,
    bool? dotAll,
    bool? replaceMode,
    bool? keyboardMode,
  }) =>
      RegExpConfig(
        multiLine: multiLine ?? this.multiLine,
        keyboardMode: keyboardMode ?? this.keyboardMode,
        caseSensitive: caseSensitive ?? this.caseSensitive,
        unicode: unicode ?? this.unicode,
        dotAll: dotAll ?? this.dotAll,
        replaceMode: replaceMode ?? this.replaceMode,
      );

  @override
  String toString() {
    return 'RegExpConfig{multiLine: $multiLine, caseSensitive: $caseSensitive, unicode: $unicode, dotAll: $dotAll, replaceMode: $replaceMode, keyboardMode: $keyboardMode}';
  }

  @override
  List<Object?> get props => [
        multiLine,
        caseSensitive,
        unicode,
        dotAll,
        replaceMode,
        keyboardMode,
      ];
}
