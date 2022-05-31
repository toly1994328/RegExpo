import 'package:equatable/equatable.dart';

class RegExample extends Equatable{
  final int id;
  final String title;
  final String subtitle;
  final List<String> recommend;
  final String content;

  RegExample({
    required this.id,
    required this.title,
    required this.subtitle,
    this.recommend = const [],
    required this.content,
  });

  factory RegExample.fromJson(Map<String, dynamic> map) {
    List<dynamic> recommend = map["recommend"];

    return RegExample(
        id: map['id'],
        title: map['title'],
        subtitle: map["subtitle"],
        recommend: recommend.map((e) => e.toString()).toList(),
        content: map["content"]);
  }

  @override
  String toString() {
    return 'RegTestItem{title: $title, subtitle: $subtitle, recommend: $recommend, content: $content}';
  }

  @override
  List<Object?> get props => [id];
}
