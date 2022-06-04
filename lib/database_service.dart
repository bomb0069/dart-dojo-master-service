import 'dart:io';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  bool isDbReady = true;

  Future<Database> generateDatabase() async {
    while (!isDbReady) {
      print(
          'DatabaseConnectionService : getDatabase : ----------------------------------------- Database.isNotReady -----------------------------------------');
      await Future.delayed(const Duration(seconds: 1));
    }
    var db = await databaseFactoryFfi.openDatabase(
        '/Volumes/Work/lab/dart/master/first.db',
        options: OpenDatabaseOptions(
            onCreate: (database, version) async {
              await database.execute('''
                CREATE TABLE IF NOT EXISTS PRODUCT (
                  ID	INT,
                  NAME	TEXT,
                  PRIMARY KEY("ID")
                )
                ''');
              for (int i = 0; i < 500000; i++) {
                await database.execute('''
                  INSERT INTO "PRODUCT" ("ID","NAME") VALUES (?, ?)
                ''', [i + 1, 'bomb-' + (i + 1).toString()]);
              }
              await database.execute('''
                CREATE TABLE IF NOT EXISTS PRODUCT_DUMMY (
                  ID	INT,
                  NAME	TEXT,
                  PRIMARY KEY("ID")
                )
                ''');
            },
            version: 1,
            singleInstance: false));
    return db;
  }

  Future<Database> generateSecondDatabase() async {
    File first = File('/Volumes/Work/lab/dart/master/first.db');
    first.copy('/Volumes/Work/lab/dart/master/second.db');

    Database _db = await databaseFactoryFfi.openDatabase(
        '/Volumes/Work/lab/dart/master/second.db',
        options: OpenDatabaseOptions(singleInstance: true));

    var result4 = await _db.query("PRODUCT", where: 'id = ?', whereArgs: [1]);
    print(result4[0]['NAME']);

    return _db;
  }

  Future<Database> switchBackToFirst() async {
    Database _db = await databaseFactoryFfi.openDatabase(
        '/Volumes/Work/lab/dart/master/second.db',
        options: OpenDatabaseOptions(singleInstance: false));
    //tmp.close();
    //Database _db = await databaseFactoryFfi.openDatabase(
    //    '/Volumes/Work/lab/dart/master/first.db',
    //    options: OpenDatabaseOptions(singleInstance: false));

    isDbReady = false;

    await _db.rawQuery("ATTACH DATABASE ? as tmp",
        ['file:/Volumes/Work/lab/dart/master/first.db?mode=ro']);

//    await listDataFormSQL(
//        _db, 'select count(*) as tmp_product_count from tmp.PRODUCT');
    //await listDataFormSQL(
    //    _db, 'select count(*) as product_count from tmp.PRODUCT');
    //await listDataFormSQL(_db,
    //    'insert into product select * from tmp.PRODUCT where id > (select max(id) from PRODUCT)');

    try {
      await _db.rawQuery("DETACH DATABASE 'tmp'");
      _db.close();
      File first = File('/Volumes/Work/lab/dart/master/second.db');
      first.copy('/Volumes/Work/lab/dart/master/first.db');
    } catch (e) {
      print(e.toString());
    } finally {
      isDbReady = true;
      // File first = File('/Volumes/Work/lab/dart/master/first.db');
      // first.delete();
      File second = File('/Volumes/Work/lab/dart/master/second.db');
      second.delete();
    }

    return _db;
  }

  Future<void> listDataFormSQL(Database _db, String sql) async {
    List<Map<String, Object?>> result = await _db.rawQuery(sql);
    for (var element in result) {
      element.forEach((key, value) {
        print('$key = $value');
      });
    }
  }
}
