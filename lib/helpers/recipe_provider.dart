import 'package:munchy/model/recipe.dart';
import 'package:munchy/helpers/network_helper.dart';

const String apiKey = "f2007f6cd6b0479eacff63b69ec08ebd";
const String mainURL = "https://api.spoonacular.com/recipes/";

class RecipeProvider {
  var _networkHelper;
  RecipeProvider();

  // =================== RECIPE API CALLS =====================

  Future<List<Recipe>> getRandomRecipesData(int numOfRecs,
      {String recipeType}) async {
    if (recipeType != null) {
      _networkHelper = NetworkHelper(
          url: mainURL +
              "random?number=$numOfRecs&tags=$recipeType&apiKey=$apiKey");
    } else {
      _networkHelper = NetworkHelper(
          url: mainURL + "random?number=$numOfRecs&apiKey=$apiKey");
    }
    var tempRecipes = await _networkHelper.getData();
    List<Recipe> recipeList = [];
    for (int i = 0; i < numOfRecs; i++) {
      recipeList.add(Recipe.fromJson(tempRecipes['recipes'][i], 1));
    }
    return recipeList;
  }

  Future<List<Recipe>> getRecipesWithIngs(List<String> ingNames, int numOfRecs,
      {String recipeType}) async {
    ingNames.shuffle();
    String stringifiedIngs = "";
    int countUntil = ingNames.length > 3 ? 3 : ingNames.length;
    for (int i = 0; i < countUntil; i++) {
      if (i == countUntil - 1) {
        stringifiedIngs += ingNames[i];
      } else {
        stringifiedIngs += ingNames[i] + ",+";
      }
    }
    if (recipeType != null) {
      _networkHelper = NetworkHelper(
          url: mainURL +
              "findByIngredients?ingredients=$stringifiedIngs&number=$numOfRecs&tags=$recipeType&apiKey=$apiKey");
    } else {
      _networkHelper = NetworkHelper(
          url: mainURL +
              "findByIngredients?ingredients=$stringifiedIngs&number=$numOfRecs&apiKey=$apiKey");
    }
    var tempRecipes = await _networkHelper.getData();

    var recsToReturn = [];
    for (int i = 0; i < numOfRecs; i++) {
      var idOfCurrentRec = tempRecipes[i]['id'];
      var url = mainURL + "$idOfCurrentRec/information?apiKey=$apiKey";
      _networkHelper = NetworkHelper(url: url);
      var tempRec = await _networkHelper.getData();
      recsToReturn.add(tempRec);
    }

    List<Recipe> recipeList = [];
    for (int i = 0; i < numOfRecs; i++) {
      try {
        recipeList.add(Recipe.fromJson(recsToReturn[i], 1));
      } catch (e) {
        print(e);
        recipeList = [];
      }
    }
    return recipeList;
  }
}
