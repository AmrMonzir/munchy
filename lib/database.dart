import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  List<List<dynamic>> data = [];
  // Ingredient constants (Table/columns)
  static const String TABLE_INGREDIENTS = "ingredients";
  static const String COLUMN_ING_ID = 'id';
  static const String COLUMN_ING_NAME = 'name';
  static const String COLUMN_ING_ISESSENTIAL = "is_essential";
  static const String COLUMN_ING_ISAVAILABLE = "is_available";
  static const String COLUMN_ING_NQUANTITY = "amount";
  static const String COLUMN_ING_KGQUANTITY = "quantity_kg";
  static const String COLUMN_ING_LRQUANTITY = "quantity_lr";
  static const String COLUMN_ING_IMAGE = "image";
  static const String COLUMN_ING_AISLE = "aisle";
  static const String COLUMN_ING_UNIT = "unit";

  static const String TABLE_RECIPES = "recipes";
  static const String COLUMN_REC_ID = 'id';
  static const String COLUMN_REC_IMAGE = "image";
  static const String COLUMN_REC_SERVINGS = "servings";
  static const String COLUMN_REC_TITLE = "title";
  static const String COLUMN_REC_INGSLIST = "extendedIngredients";
  static const String COLUMN_REC_SUMMARY = "summary";
  static const String COLUMN_REC_FAVORITE = "is_favorite";
  static const String COLUMN_REC_INSTRUCTIONS = "analyzedInstructions";
  static const String COLUMN_REC_DISH_TYPES = "dishTypes";
  static const String COLUMN_REC_CHEAP = "cheap";
  static const String COLUMN_REC_HEALTHSCORE = "healthScore";
  static const String COLUMN_REC_SOURCE_URL = "spoonacularSourceUrl";
  static const String COLUMN_REC_READY_IN_MINUTES = "readyInMinutes";
  static const String COLUMN_REC_SOURCE_NAME = "sourceName";

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
            $COLUMN_ING_NQUANTITY REAL,
            $COLUMN_ING_LRQUANTITY REAL,
            $COLUMN_ING_IMAGE TEXT,
            $COLUMN_ING_AISLE TEXT,
            $COLUMN_ING_UNIT TEXT)''');

        await db.execute('''CREATE TABLE $TABLE_RECIPES (
            $COLUMN_REC_ID INTEGER PRIMARY KEY, 
            $COLUMN_REC_TITLE TEXT, 
            $COLUMN_REC_IMAGE TEXT,
            $COLUMN_REC_SERVINGS INTEGER,
            $COLUMN_REC_INGSLIST TEXT,
            $COLUMN_REC_INSTRUCTIONS TEXT,
            $COLUMN_REC_CHEAP INTEGER,
            $COLUMN_REC_DISH_TYPES TEXT,
            $COLUMN_REC_FAVORITE INTEGER,
            $COLUMN_REC_HEALTHSCORE DOUBLE,
            $COLUMN_REC_READY_IN_MINUTES INTEGER,
            $COLUMN_REC_SOURCE_URL TEXT,
            $COLUMN_REC_SOURCE_NAME TEXT,
            $COLUMN_REC_SUMMARY)''');

        print("done creating db tables");
      },
    );
  }
}
