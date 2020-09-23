import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:csv/csv.dart';

class DBProvider {
  List<List<dynamic>> data = [];
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
  static const String COLUMN_ING_ISAVAILABLE = "is_available";
  static const String COLUMN_ING_NQUANTITY = "quantity_number";
  static const String COLUMN_ING_KGQUANTITY = "quantity_kg";
  static const String COLUMN_ING_LRQUANTITY = "quantity_lr";
  static const String COLUMN_ING_IMAGE = "image";
  static const String COLUMN_ING_AISLE = "aisle";

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
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $TABLE_INGREDIENTS (
            $COLUMN_ING_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
            $COLUMN_ING_NAME TEXT, 
            $COLUMN_ING_ISESSENTIAL INTEGER,
            $COLUMN_ING_ISAVAILABLE INTEGER,
            $COLUMN_ING_KGQUANTITY REAL,
            $COLUMN_ING_NQUANTITY INTEGER,
            $COLUMN_ING_LRQUANTITY REAL,
            $COLUMN_ING_IMAGE TEXT,
            $COLUMN_ING_AISLE TEXT)''');

        await db
            .rawQuery("SELECT * FROM $TABLE_INGREDIENTS")
            .then((value) => print(value));
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
