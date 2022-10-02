import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:project/db/dbProvider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class UserDB {
  static const String tableName = "user";
  static const String _uid = "id";
  static const String _uname = "name";
  static const String _pwd = "pwd";
  static const String _token = "api_token";
  static const String _gender = "gender";
  static const String _avatar = "avatar";
  static const String _phoneNumber = "phone_Number";
  static const String _email = "email";
  static const String createString = '''
    create table $tableName (
      $_uid integer,
      $_uname text not null,
      $_token text,
      $_gender text,
      $_avatar text,
      $_phoneNumber Integer,
      $_email Text
    )
  ''';

  Future<bool> verify(String username, String pwd) async {
    Database? db = await DBProvider.instance.db;
    debugPrint("$username, $pwd");
    List<Map<String, dynamic>> res =
        await db!.query(tableName, where: "$_uname = ? and $_pwd = ?", whereArgs: [username, pwd]);
    debugPrint(res.toString());
    return res.isEmpty ? false : true;
  }

  Future<void> addToken(User user) async {
    Database? db = await DBProvider.instance.db;
    int? count = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM User where id = ?', [user.id]));
    if (count == 0) {
      await db.rawDelete('DELETE FROM USER');
      await db.rawInsert(
          'INSERT INTO USER(id,name,api_token)VALUES(?,?,?)', [user.id, user.name, user.token]);
    } else {
      await db.rawQuery('UPDATE USER SET API_TOKEN=? WHERE ID = ?', [user.token, user.id]);
    }
  }

  Future<User> getUser() async {
    Database? db = await DBProvider.instance.db;
    User user = User.empty();
    List<Map<String, dynamic>> map = await db!.query('User');
    if (map.isNotEmpty) {
      Map<String, dynamic> json = map.first;
      user.formJson(json);
    }

    return user;
  }
}
