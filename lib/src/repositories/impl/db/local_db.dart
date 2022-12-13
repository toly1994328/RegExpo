import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'dao/link_regex_dao.dart';
import 'dao/record_dao.dart';
import 'helper/db_open_helper.dart';
import '../../../models/record/record.dart';
import 'update/db_updater.dart';

class LocalDb {
  Database? _database;

  LocalDb._();

  static LocalDb instance = LocalDb._();

  final DbOpenHelper helper = const DbOpenHelper();

  late RecoderDao _recoderDao;
  RecoderDao get recoderDao => _recoderDao;

  late LinkRegexDao _linkRegexDao;
  LinkRegexDao get linkRegexDao => _linkRegexDao;

  Future<void> initDb({String name = "regexpo.db"}) async {
    if (_database != null) return;
    helper.setupDatabase();
    String databasesPath = await helper.getDbDirPath();
    String dbPath = path.join(databasesPath, name);

    print('====数据库所在文件夹: $dbPath=======');

    OpenDatabaseOptions options = OpenDatabaseOptions(
        version: DbUpdater.version,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen);

    if (Platform.isWindows || Platform.isLinux) {
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      _database = await databaseFactory.openDatabase(
        dbPath,
        options: options,
      );
      return;
    }
    _database = await openDatabase(
      dbPath,
      version: options.version,
      onCreate: options.onCreate,
      onUpgrade: options.onUpgrade,
      onOpen: options.onOpen,
    );
  }

  Future<void> closeDb() async {
    await _database?.close();
    _database = null;
  }

  final DbUpdater updater = DbUpdater();

  FutureOr<void> _onCreate(Database db, int version) async{
    print('数据库创建....');
    await Future.wait([
      db.execute(Record.tableSql),
      updater.update(db, 1, version)
    ]);
  }
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    await updater.update(db, oldVersion, newVersion);
  }

  FutureOr<void> _onOpen(Database db) {
    print('数据库打开....');
    _recoderDao = RecoderDao(db);
    _linkRegexDao = LinkRegexDao(db);
  }
}
