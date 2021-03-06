import 'dart:convert';

final String idColumn = 'id';
final String nameColumn = 'name';
final String isEssentialColumn = "is_essential";
final String kgQuantityColumn = "quantity_kg";
final String lrQuantityColumn = "quantity_lr";
final String nQuantityColumn = "quantity_n";
final String essentialThresholdColumn = "essential_threshold";
final String essentialUnitColumn = "essential_unit";
final String imageColumn = "image";
final String aisleColumn = "aisle";
final String unitColumn = "unit";
final String amountForAPIRecipesColumn = "amount";

Ingredient ingredientFromJson(String str) =>
    Ingredient.fromDatabaseJson(json.decode(str));

String ingredientToJson(Ingredient data) => json.encode(data.toDatabaseJson());

class Ingredient {
  final String name;
  final String aisle;
  final String image;
  final int id;
  bool isEssential;
  String essentialUnit;
  final bool isAvailable;
  double amountForAPIRecipes;
  double nQuantity;
  double kgQuantity;
  double lrQuantity;
  double essentialThreshold;
  String unit;

  // Ingredient constants (Table/columns)

  Ingredient(
      {this.name,
      this.id,
      this.aisle,
      this.isEssential,
      this.image,
      this.essentialUnit,
      this.isAvailable,
      this.amountForAPIRecipes,
      this.kgQuantity,
      this.lrQuantity,
      this.nQuantity,
      this.essentialThreshold,
      this.unit});

  factory Ingredient.fromDatabaseJson(Map<String, dynamic> json) => Ingredient(
        //Factory method will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into an Ingredient object

        id: json[idColumn],
        name: json[nameColumn],
        aisle: json[aisleColumn],
        image: json[imageColumn],
        essentialThreshold: json[essentialThresholdColumn],
        essentialUnit: json[essentialUnitColumn],
        amountForAPIRecipes: json[amountForAPIRecipesColumn],
        nQuantity: json[nQuantityColumn],
        kgQuantity: json[kgQuantityColumn],
        lrQuantity: json[lrQuantityColumn],
        isAvailable: (json[nQuantityColumn] != null ||
                json[kgQuantityColumn] != null ||
                json[lrQuantityColumn] != null) &&
            (json[nQuantityColumn] > 0 ||
                json[kgQuantityColumn] > 0 ||
                json[lrQuantityColumn] > 0),
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
        amountForAPIRecipesColumn: this.amountForAPIRecipes,
        isEssentialColumn: this.isEssential == false ? 0 : 1,
        nQuantityColumn: this.nQuantity,
        kgQuantityColumn: this.kgQuantity,
        lrQuantityColumn: this.lrQuantity,
        essentialThresholdColumn: this.essentialThreshold,
        essentialUnitColumn: this.essentialUnit,
        unitColumn: this.unit,
      };
}
