import 'dart:async';
import 'package:munchy/database.dart';
import 'ingredient.dart';

// Database access object - to facilitate access to database by ingredient object
class IngredientsDao {
  final dbProvider = DBProvider.db;

  //Adds new ingredients
  Future<int> createIng(Ingredient ingredient) async {
    final db = await dbProvider.database;
    var result = await db.insert(
        DBProvider.TABLE_INGREDIENTS, ingredient.toDatabaseJson());

    //TODO delete this, it's just for printing items when creating ing, not needed in release
    await db
        .rawQuery('SELECT * FROM ${DBProvider.TABLE_INGREDIENTS}')
        .then((value) {
      print(value.toString());
    });

    return result;
  }

  Future<Ingredient> getIng(int id) async {
    final db = await dbProvider.database;

    var result = await db
        .query(DBProvider.TABLE_INGREDIENTS, where: " id = ?", whereArgs: [id]);

    List<Ingredient> ing = result.map((e) => Ingredient.fromDatabaseJson(e));

    return ing.first;
  }

  //Get All Ingredient items
  //Searches if query string was passed
  Future<List<Ingredient>> getIngs({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(DBProvider.TABLE_INGREDIENTS,
            columns: columns, where: 'name LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(DBProvider.TABLE_INGREDIENTS, columns: columns);
    }

    List<Ingredient> ings = result.isNotEmpty
        ? result.map((item) => Ingredient.fromDatabaseJson(item)).toList()
        : [];
    return ings;
  }

  //Update Ingredient record
  Future<int> updateIng(Ingredient ingredient) async {
    final db = await dbProvider.database;

    var args = [
      ingredient.id,
      ingredient.name,
      ingredient.isAvailable,
      ingredient.nQuantity,
      ingredient.kgQuantity,
      ingredient.lrQuantity
    ];

    var result = await db.update(
        DBProvider.TABLE_INGREDIENTS, ingredient.toDatabaseJson(),
        where:
            '''${DBProvider.COLUMN_ING_ID} = ? AND ${DBProvider.COLUMN_ING_NAME} = ? AND ${DBProvider.COLUMN_ING_ISAVAILABLE} = ? AND ${DBProvider.COLUMN_ING_NQUANTITY} = ? AND ${DBProvider.COLUMN_ING_KGQUANTITY} = ? AND ${DBProvider.COLUMN_ING_LRQUANTITY} = ? ''',
        whereArgs: args);

    await db
        .rawQuery('SELECT * FROM ${DBProvider.TABLE_INGREDIENTS}')
        .then((value) {
      print(value.toString());
    });

    return result;
  }

  //Delete Ingredient records
  Future<int> deleteIng(int id) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(DBProvider.TABLE_INGREDIENTS, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllIngs() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      DBProvider.TABLE_INGREDIENTS,
    );

    return result;
  }
}