import 'dart:async';
import 'package:munchy/database.dart';
import 'recipe.dart';

// Database access object - to facilitate access to database by ingredient object
class RecipesDao {
  final dbProvider = DBProvider.db;

  //Adds new ingredients
  Future<int> createRec(Recipe recipe) async {
    final db = await dbProvider.database;
    var result = await db.insert(DBProvider.TABLE_RECIPES, recipe.toJson());

    //TODO delete this, it's just for printing items when creating recipes, not needed in release
    await db
        .rawQuery('SELECT * FROM ${DBProvider.TABLE_RECIPES}')
        .then((value) {
      print(value.toString());
    });

    return result;
  }

  Future<Recipe> getRec(int id) async {
    final db = await dbProvider.database;

    var result = await db
        .query(DBProvider.TABLE_RECIPES, where: " id = ?", whereArgs: [id]);

    List<Recipe> ing = result.map((e) => Recipe.fromJson(e));

    return ing.first;
  }

  //Get All Ingredient items
  //Searches if query string was passed
  Future<List<Recipe>> getRecs({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(DBProvider.TABLE_RECIPES,
            columns: columns, where: 'name LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(DBProvider.TABLE_RECIPES, columns: columns);
    }

    List<Recipe> recs = result.isNotEmpty
        ? result.map((item) => Recipe.fromJson(item)).toList()
        : [];
    return recs;
  }

  // Don't need update so far...

  //Delete Ingredient records
  Future<int> deleteRec(int id) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(DBProvider.TABLE_RECIPES, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllRecs() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      DBProvider.TABLE_RECIPES,
    );
    return result;
  }
}