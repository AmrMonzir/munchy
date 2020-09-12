final String idColumn = 'id';
final String nameColumn = 'name';
final String isEssentialColumn = "is_essential";

class Ingredient {
  final String name;
  final int id;
  final bool isEssential;
  // static List<Ingredient> _listOfAllIngredients = [];

  // Ingredient constants (Table/columns)

  Ingredient({this.name, this.id, this.isEssential});

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
        isEssential: data[isEssentialColumn] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        //A method will be used to convert Ingredient objects that
        //are to be stored into the database in a form of JSON

        idColumn: this.id,
        nameColumn: this.name,
        isEssentialColumn: this.isEssential == false ? 0 : 1,
      };
}
