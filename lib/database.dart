import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/fridge.dart';

class DBProvider {
  // Fridge constants (Table/columns)
  static const String TABLE_FRIDGES = 'fridge';
  static const String COLUMN_FRG_ID = 'id';
  static const String COLUMN_FIRST_MEMBER = 'first_member';
  static const String COLUMN_SECOND_MEMBER = 'second_member';
  static const String COLUMN_INGREDIENTS = 'ingredients';

  // Ingredient constants (Table/columns)
  static const String TABLE_INGREDIENTS = "ingredients";
  static const String COLUMN_ING_ID = 'id';
  static const String COLUMN_ING_NAME = 'name';
  static const String COLUMN_ING_ISESSENTIAL = "is_essential";

  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MunchyDB.db");
    print("initialized db:" + path);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $TABLE_INGREDIENTS (
            $COLUMN_ING_ID INTEGER PRIMARY KEY, 
            $COLUMN_ING_NAME TEXT, 
            $COLUMN_ING_ISESSENTIAL INTEGER)''');

        await db.rawInsert(
            'INSERT INTO $TABLE_INGREDIENTS ($COLUMN_ING_NAME, $COLUMN_ING_ISESSENTIAL) VALUES ("Flour", 1)');
        await db.rawInsert(
            'INSERT INTO $TABLE_INGREDIENTS ($COLUMN_ING_NAME, $COLUMN_ING_ISESSENTIAL) VALUES ("Apple", 1)');
        await db.rawInsert(
            'INSERT INTO $TABLE_INGREDIENTS ($COLUMN_ING_NAME, $COLUMN_ING_ISESSENTIAL) VALUES ("Flour", 1)');
      },
    );
  }

  // Future<List<Ingredient>> getIngredients() async {
//   //   final db = await database;
//   //   var ingredients = await db.query(TABLE_INGREDIENTS, columns: [
//   //     COLUMN_ING_ID,
//   //     COLUMN_ING_NAME,
//   //   ]);
//   //
//   //   List<Ingredient> ingredientList = List<Ingredient>();
//   //
//   //   ingredients.forEach((currentIngredient) {
//   //     Ingredient ingredient = Ingredient.fromMap(currentIngredient);
//   //     ingredientList.add(ingredient);
//   //   });
//   //   return ingredientList;
//   // }
//   //
//   // Future<Ingredient> insertIngredient(Ingredient ingredient) async {
//   //   final db = await database;
//   //   ingredient.id = await db.insert(TABLE_INGREDIENTS, ingredient.toMap());
//   //   print("inserted ingredient: " + ingredient.name);
//   //   return ingredient;
//   // }
//   //
//   // Future<Ingredient> deleteIngredient(Ingredient ingredient) async {
//   //   final db = await database;
//   //   ingredient.id =
//   //       await db.delete(TABLE_INGREDIENTS, where: "name = ${ingredient.name}");
//   //   print("inserted ingredient: " + ingredient.name);
//   //   return ingredient;
//   // }
//   //
//   // Future<List<Fridge>> getFridges() async {
//   //   final db = await database;
//   //
//   //   var fridges = await db.query(TABLE_FRIDGES, columns: [
//   //     COLUMN_FRG_ID,
//   //     COLUMN_FIRST_MEMBER,
//   //     COLUMN_SECOND_MEMBER,
//   //     COLUMN_INGREDIENTS
//   //   ]);
//   //
//   //   List<Fridge> fridgeList = List<Fridge>();
//   //
//   //   fridges.forEach((currentFridge) {
//   //     Fridge fridge = Fridge.fromMap(currentFridge);
//   //     fridgeList.add(fridge);
//   //   });
//   //
//   //   return fridgeList;
//   // }
//   //
//   // Future<Fridge> insertFridge(Fridge fridge) async {
//   //   final db = await database;
//   //   fridge.id = await db.insert(TABLE_FRIDGES, fridge.toMap());
//   //   print("inserted fridge");
//   //   return fridge;
//   // }
}

// await db.execute("CREATE TABLE $TABLE_FRIDGES ("
//     "$COLUMN_FRG_ID INTEGER PRIMARY KEY,"
//     "$COLUMN_FIRST_MEMBER TEXT,"
//     "$COLUMN_SECOND_MEMBER TEXT,"
//     "$COLUMN_INGREDIENTS TEXT"
//     ")");
