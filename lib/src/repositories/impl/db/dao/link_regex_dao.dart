import 'package:regexpo/src/models/models.dart';
import 'package:sqflite/sqflite.dart';

class LinkRegexDao {
  final Database _database;

  LinkRegexDao(this._database);

  Future<List<Map<String, Object?>>> queryLinkRegexByRecordId(int recordId) {
    return _database.query('link_regex',
        where: 'record_id = ?',
        whereArgs: [recordId],
        orderBy: "timestamp DESC");
  }

  Future<int> insert(LinkRegex data) => _database.insert(
        'link_regex',
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<int> deleteById(int id) => _database.delete(
        'link_regex',
        where: "id = ?",
        whereArgs: [id],
      );

  Future<int> update(LinkRegex data) => _database.update(
        'link_regex',
        data.toJson(),
        where: "id = ?",
        whereArgs: [data.id],
      );
}
