import 'dart:async';
import 'package:munchy/database.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class UserDao {
  final dbProvider = DBProvider.db;

  Future<int> storeUser(AppUser user) async {
    final db = await dbProvider.database;
    var result = await db.insert(DBProvider.TABLE_USERS, user.toMap());

    //TODO delete this, it's just for printing items when creating recipes, not needed in release
    await db.rawQuery('SELECT * FROM ${DBProvider.TABLE_USERS}').then((value) {
      print(value.toString());
    });

    return result;
  }

  Future<AppUser> getUser(String id) async {
    final db = await dbProvider.database;

    var result = await db
        .query(DBProvider.TABLE_USERS, where: "uid = ?", whereArgs: ["$id"]);

    List<AppUser> user = result.map((e) => AppUser.fromJson(e)).toList();

    await db
        .rawQuery(
            'SELECT * FROM ${DBProvider.TABLE_USERS} where ${DBProvider.COLUMN_USER_UID} = "$id"')
        .then((value) {
      print(value.toString());
    });

    return user.first;
  }

  Future<int> deleteUser(String id) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(DBProvider.TABLE_USERS, where: 'uid = ?', whereArgs: ["$id"]);

    return result;
  }

  Future<int> updateUser(AppUser user) async {
    final db = await dbProvider.database;

    var result = await db.update(DBProvider.TABLE_USERS, user.toMap(),
        where: '''${DBProvider.COLUMN_USER_UID} = ?''',
        whereArgs: ["${user.id}"]);

    // To print results TODO: delete
    await db
        .rawQuery(
            'SELECT * FROM ${DBProvider.TABLE_USERS} where ${DBProvider.COLUMN_USER_UID} = "${user.id}"')
        .then((value) {
      print(value.toString());
    });

    return result;
  }

  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      DBProvider.TABLE_USERS,
    );

    return result;
  }
}
