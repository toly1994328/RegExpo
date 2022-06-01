class RegExpConfig {
  final bool multiLine;
  final bool caseSensitive;
  final bool unicode;
  final bool dotAll;

  const RegExpConfig(
      {this.multiLine = false,
      this.caseSensitive = true,
      this.unicode = false,
      this.dotAll = false});

  RegExpConfig copyWith(
          {bool? multiLine,
          bool? caseSensitive,
          bool? unicode,
          bool? dotAll}) =>
      RegExpConfig(
        multiLine: multiLine ?? this.multiLine,
        caseSensitive: caseSensitive ?? this.caseSensitive,
        unicode: unicode ?? this.unicode,
        dotAll: dotAll ?? this.dotAll,
      );
}
