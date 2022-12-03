import 'package:sqflite/sqflite.dart';

import '../../../../models/link_regex/link_regex.dart';
import 'db_migration.dart';

class DbUpdater {
  static const version = 3;

  Future<void> update(Database db, int oldVersion, int newVersion) async {
    print('-------_onUpgrade---oldVersion:$oldVersion--newVersion$newVersion-');
    DbMigration dbMigration = DbMigration();
    dbMigration.addMigration(1, migration_1_2);
    dbMigration.addMigration(2, migration_2_3);
    await dbMigration.migration(db, oldVersion, newVersion);
  }

  Future<void> migration_1_2(Database database) async {
    String sql = "ALTER TABLE recoder ADD COLUMN timestamp INTEGER DEFAULT 0";
    await database.execute(sql);
  }

  Future<void> migration_2_3(Database database) async {
    await database.execute(LinkRegex.tableSql);
  }
}
