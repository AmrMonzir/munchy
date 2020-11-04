import 'dart:convert';

final String idColumn = 'id';
final String nameColumn = 'name';
final String isEssentialColumn = "is_essential";
final String isAvailableColumn = "is_available";
final String kgQuantityColumn = "quantity_kg";
final String lrQuantityColumn = "quantity_lr";
final String nQuantityColumn = "amount";
final String imageColumn = "image";
final String aisleColumn = "aisle";
final String unitColumn = "unit";

Ingredient ingredientFromJson(String str) =>
    Ingredient.fromDatabaseJson(json.decode(str));

String ingredientToJson(Ingredient data) => json.encode(data.toDatabaseJson());

class Ingredient {
  final String name;
  final String aisle;
  final String image;
  final int id;
  final bool isEssential;
  final bool isAvailable;
  double nQuantity;
  double kgQuantity;
  double lrQuantity;
  final String unit;
  // static List<Ingredient> _listOfAllIngredients = [];

  // Ingredient constants (Table/columns)

  Ingredient(
      {this.name,
      this.id,
      this.aisle,
      this.isEssential,
      this.image,
      this.isAvailable,
      this.kgQuantity,
      this.lrQuantity,
      this.nQuantity,
      this.unit});

  factory Ingredient.fromDatabaseJson(Map<String, dynamic> json) => Ingredient(
        //Factory method will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into an Ingredient object

        id: json[idColumn],
        name: json[nameColumn],
        aisle: json[aisleColumn],
        image: json[imageColumn],
        isAvailable: json[isAvailableColumn] == 0 ? false : true,
        nQuantity: json[nQuantityColumn],
        kgQuantity: json[kgQuantityColumn],
        lrQuantity: json[lrQuantityColumn],
        isEssential: json[isEssentialColumn] == 0 ? false : true,
        unit: json[unitColumn],
      );

  Map<String, dynamic> toDatabaseJson() => {
        //A method will be used to convert Ingredient objects that
        //are to be stored into the database in a form of JSON

        idColumn: this.id,
        nameColumn: this.name,
        aisleColumn: this.aisle,
        imageColumn: this.image,
        isEssentialColumn: this.isEssential == false ? 0 : 1,
        isAvailableColumn: this.isAvailable == false ? 0 : 1,
        nQuantityColumn: this.nQuantity,
        kgQuantityColumn: this.kgQuantity,
        lrQuantityColumn: this.lrQuantity,
        unitColumn: this.unit,
      };
}
