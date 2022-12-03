class LinkRegex{
  // 关联正则表
  static const String tableSql = """
CREATE TABLE `link_regex` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `regex` TEXT ,
  `record_id` INTEGER,
  `timestamp` INTEGER,
  UNIQUE(record_id,regex)
)
""";

  final int id;
  final String regex;
  final int recordId;
  final int timestamp;

  const LinkRegex({
    required this.id,
    required this.regex,
    required this.recordId,
    required this.timestamp,
  });

  LinkRegex.i({
    this.id = -1,
    required this.regex,
    required this.recordId,
  }) : timestamp = DateTime.now().millisecondsSinceEpoch;

  factory LinkRegex.fromJson(dynamic map) {
    return LinkRegex(
      id: map['id'],
      regex: map['regex'],
      recordId: map["record_id"],
      timestamp: map["timestamp"],
    );
  }

  LinkRegex copyWith({
    int? id,
    String? regex,
    int? recordId,
    int? timestamp,
  }) {
    return LinkRegex(
      id: id ?? this.id,
      regex: regex ?? this.regex,
      recordId: recordId ?? this.recordId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id == -1 ? null : id,
    "regex": regex,
    "record_id": recordId,
    "timestamp": timestamp,
  };

  @override
  String toString() => regex;
}