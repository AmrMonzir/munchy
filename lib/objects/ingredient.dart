class Ingredient {
  String name;
  String id;
  static List<Ingredient> _listOfAllIngredients = [];

  Ingredient({this.name, this.id});

  void addToListOfIngredients(Ingredient ingredient) {
    _listOfAllIngredients.add(ingredient);
  }

  List<Ingredient> getListofAllIngredients() {
    return _listOfAllIngredients;
  }
}
