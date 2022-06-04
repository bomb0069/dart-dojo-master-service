@Timeout(Duration(seconds: 120))

import 'dart:isolate';

import 'package:master/database_service.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test/test.dart';

void main() {
  // Init ffi loader if needed.
  test('simple sqflite example', () async {
    var stopwatch = Stopwatch();
    stopwatch.start();
    DatabaseService databaseService = DatabaseService();
    Database db = await databaseService.generateDatabase();
    print('generateDatabase : ' + stopwatch.elapsedMilliseconds.toString());
    print(
        'generateSecondDatabase : ' + stopwatch.elapsedMilliseconds.toString());

    db.rawQuery('select * from product where id =1').then((value) => print(
        'after select before : ' + stopwatch.elapsedMilliseconds.toString()));

    print('before insert into : ' + stopwatch.elapsedMilliseconds.toString());
    _parseInBackground().then((value) {
      print('after insert into : ' +
          value +
          ' : ' +
          stopwatch.elapsedMilliseconds.toString());
      _switchBackToDB();
    });
    for (int i = 0; i <= 150; i++) {
      Database db3 = await databaseService.generateDatabase();
      //int i = 0;
      print('before select * : ' +
          i.toString() +
          ' : ' +
          stopwatch.elapsedMilliseconds.toString());
      db3.rawQuery('select * from product where id =\'$i\'').then((value) =>
          print('after select * : ' +
              i.toString() +
              ' : ' +
              stopwatch.elapsedMilliseconds.toString()));
      await Future.delayed(Duration(milliseconds: 10));
      if (i % 10 == 0) {
        print('before INSERT INTO record (first.db) -------------- : ' +
            (i + 500001).toString() +
            ' : ' +
            stopwatch.elapsedMilliseconds.toString());
        Database db3 = await databaseService.generateDatabase();
        await db3.execute('''
        INSERT INTO "PRODUCT" ("ID","NAME") VALUES (?, ?)
      ''', [(i + 500001), 'bomb-' + (i + 500001).toString()]);
      }
    }

    print('ending : ' + stopwatch.elapsedMilliseconds.toString());
    //await Future.delayed(Duration(seconds: 50));
  });
}

Future<String> _parseInBackground() async {
  final p = ReceivePort();
  await Isolate.spawn(querySecondDatabase, p.sendPort);
  return await p.first as String;
  //return await p.first as Map<String, dynamic>;
}

Future<void> querySecondDatabase(SendPort p) async {
  var stopwatch = Stopwatch();
  stopwatch.start();
  DatabaseService databaseService = DatabaseService();

  Database db2 = await databaseService.generateSecondDatabase();
  await db2.rawQuery('delete from product_dummy');
  print('----------- (second.db) > before inner insert into : ' +
      stopwatch.elapsedMilliseconds.toString());
  await db2.rawQuery('insert into product_dummy select * from product').then(
      (value) => print('----------- (second.db) > after inner insert into : ' +
          stopwatch.elapsedMilliseconds.toString()));

  await db2.rawQuery('delete from product_dummy');
  print('----------- (second.db) > before inner insert into : ' +
      stopwatch.elapsedMilliseconds.toString());
  await db2.rawQuery('insert into product_dummy select * from product').then(
      (value) => print('----------- (second.db) > after inner insert into : ' +
          stopwatch.elapsedMilliseconds.toString()));

  await db2.rawQuery('delete from product_dummy');
  print('----------- (second.db) > before inner insert into : ' +
      stopwatch.elapsedMilliseconds.toString());
  await db2.rawQuery('insert into product_dummy select * from product').then(
      (value) => print('----------- (second.db) > after inner insert into : ' +
          stopwatch.elapsedMilliseconds.toString()));

  await db2.rawQuery('delete from product_dummy');
  print('----------- (second.db) > before inner insert into : ' +
      stopwatch.elapsedMilliseconds.toString());
  await db2.rawQuery('insert into product_dummy select * from product').then(
      (value) => print('----------- (second.db) > after inner insert into : ' +
          stopwatch.elapsedMilliseconds.toString()));

  Isolate.exit(p, 'jsonData');
}

Future<String> _switchBackToDB() async {
  final p = ReceivePort();
  await Isolate.spawn(swithBack, p.sendPort);
  return await p.first as String;
  //return await p.first as Map<String, dynamic>;
}

Future<void> swithBack(SendPort p) async {
  var stopwatch = Stopwatch();
  stopwatch.start();
  DatabaseService databaseService = DatabaseService();

  //Database db2 = await databaseService.switchBackToFirst();
  print('----------------------> db2.close : ' +
      stopwatch.elapsedMilliseconds.toString());
  Isolate.exit(p, 'jsonData');
}
