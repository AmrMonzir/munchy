final String idColumn = 'id';
final String nameColumn = 'name';
final String isEssentialColumn = "is_essential";
final String isAvailableColumn = "is_available";
final String kgQuantityColumn = "quantity_kg";
final String lrQuantityColumn = "quantity_lr";
final String nQuantityColumn = "quantity_number";

class Ingredient {
  final String name;
  final int id;
  final bool isEssential;
  final bool isAvailable;
  final int nQuantity;
  final double kgQuantity;
  final double lrQuantity;

  // static List<Ingredient> _listOfAllIngredients = [];

  // Ingredient constants (Table/columns)

  Ingredient(
      {this.name,
      this.id,
      this.isEssential,
      this.isAvailable,
      this.kgQuantity,
      this.lrQuantity,
      this.nQuantity});

  //
  // static void addToListOfIngredients(Ingredient ingredient) {
  //   _listOfAllIngredients.add(ingredient);
  // }
  //
  // static List<Ingredient> getListOfAllIngredients() {
  //   return _listOfAllIngredients;
  // }

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{
  //     DBProvider.COLUMN_ING_NAME: name,
  //     DBProvider.COLUMN_ING_ID: id,
  //   };
  //
  //   if (id != null) {
  //     map[DBProvider.COLUMN_FRG_ID] = id;
  //   }
  //   return map;
  // }

  // Ingredient.fromMap(Map<String, dynamic> map) {
  //   id = map[DBProvider.COLUMN_ING_ID];
  //   name = map[DBProvider.COLUMN_ING_NAME];
  //   isEssential = map[DBProvider.COLUMN_ING_ISESSENTIAL];
  // }

  factory Ingredient.fromDatabaseJson(Map<String, dynamic> data) => Ingredient(
        //Factory method will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into an Ingredient object

        id: data[idColumn],
        name: data[nameColumn],
        isAvailable: data[isAvailableColumn] == 0 ? false : true,
        nQuantity: data[nQuantityColumn],
        kgQuantity: data[kgQuantityColumn],
        lrQuantity: data[lrQuantityColumn],
        isEssential: data[isEssentialColumn] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        //A method will be used to convert Ingredient objects that
        //are to be stored into the database in a form of JSON

        idColumn: this.id,
        nameColumn: this.name,
        isEssentialColumn: this.isEssential == false ? 0 : 1,
        isAvailableColumn: this.isAvailable == false ? 0 : 1,
        nQuantityColumn: this.nQuantity,
        kgQuantityColumn: this.kgQuantity,
        lrQuantityColumn: this.lrQuantity,
      };
}
