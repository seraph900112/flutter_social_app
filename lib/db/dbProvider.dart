import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project/db/userDB.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();
  static Database? _db;

  DBProvider._();

  Future<Database?> get db async {

    return _db ??= await initDB();
  }

  initDB() async {
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'myDB2.db');
    print(dataBasePath);
    return await openDatabase(path, version: 1,
        onCreate: (db, int version) async {
      await db.execute(UserDB.createString);
    });
  }
}
