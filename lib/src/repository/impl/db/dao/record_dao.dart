import 'package:sqflite/sqflite.dart';

import '../../../../models/record/record.dart';

class RecoderDao {
  final Database _database;

  RecoderDao(this._database);

  // page 1 pageSize 25 ==> 1~25
  Future<List<Map<String, Object?>>> search(
      int page, int pageSize, String? arg) {
    String? where;
    List<Object?>? whereArgs;
    if (arg != null) {
      where = "title LIKE ?";
      whereArgs = ['%$arg%'];
    }

    return _database.query('recoder',
        where: where,
        whereArgs: whereArgs,
        limit: pageSize,
        orderBy: "timestamp DESC",
        offset: (page - 1) * pageSize);
  }

  Future<int> insert(Record data) => _database.insert(
        'recoder',
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<int> deleteById(int id) => _database.delete(
        'recoder',
        where: "id = ?",
        whereArgs: [id],
      );

  Future<int> update(Record data) => _database.update(
        'recoder',
        data.toJson(),
        where: "id = ?",
        whereArgs: [data.id],
      );
}
