import 'dart:async';
import 'package:munchy/database.dart';
import 'recipe.dart';

// Database access object - to facilitate access to database by ingredient/recipe objects
// also manages connection to api and getting data
class RecipesDao {
  final dbProvider = DBProvider.db;

  //Adds new ingredients
  //create favorite rec
  Future<int> createRec(Recipe recipe) async {
    final db = await dbProvider.database;
    recipe.isFavorite = true;
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

    List<Recipe> rec = result.isNotEmpty
        ? result.map((e) => Recipe.fromJson(e, 0)).toList()
        : [];
    return rec.isEmpty ? null : rec.first;
  }

  //Get All Recipe items
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
        ? result.map((item) => Recipe.fromJson(item, 0)).toList()
        : [];
    return recs;
  }

  Future<List<Recipe>> getFavoriteRecs({int count}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (count != null) {
      result = await db.query(DBProvider.TABLE_RECIPES,
          where: "is_favorite=1", limit: count);
    } else {
      result = await db.query(DBProvider.TABLE_RECIPES, where: "is_favorite=1");
    }

    List<Recipe> recs = result.isNotEmpty
        ? result.map((e) => Recipe.fromJson(e, 0)).toList()
        : [];
    return recs;
  }

  // Don't need update so far...
  Future<int> updateRec(Recipe recipe) async {
    final db = await dbProvider.database;

    var args = [
      recipe.id,
    ];

    var result = await db.update(DBProvider.TABLE_RECIPES, recipe.toJson(),
        where: '''${DBProvider.COLUMN_REC_ID} = ?''', whereArgs: args);

    // To print results TODO: delete
    await db
        .rawQuery(
            'SELECT * FROM ${DBProvider.TABLE_RECIPES} where ${DBProvider.COLUMN_REC_ID} = ${recipe.id}')
        .then((value) {
      print(value.toString());
    });

    return result;
  }

  //Delete Recipe records
  Future<int> deleteRec(int id) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(DBProvider.TABLE_RECIPES, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllRecs() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      DBProvider.TABLE_RECIPES,
    );
    return result;
  }
}
