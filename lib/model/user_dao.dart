import 'dart:async';
import 'package:munchy/database.dart';
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

  Future<AppUser> getUser(int id) async {
    final db = await dbProvider.database;

    var result = await db
        .query(DBProvider.TABLE_USERS, where: "uid = ?", whereArgs: [id]);

    List<AppUser> ing = result.map((e) => AppUser.fromJSON(e));

    return ing.first;
  }

  Future<int> deleteUser(int uid) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(DBProvider.TABLE_USERS, where: 'uid = ?', whereArgs: [uid]);

    return result;
  }
}
