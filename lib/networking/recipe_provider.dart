import 'package:munchy/model/recipe.dart';
import 'package:munchy/networking/network_helper.dart';

const String apiKey = "f2007f6cd6b0479eacff63b69ec08ebd";
const String mainURL = "https://api.spoonacular.com/recipes/";

class RecipeProvider {
  var _networkHelper;
  RecipeProvider();

  // =================== RECIPE API CALLS =====================

  Future<List<Recipe>> getRandomRecipesData(int numOfRecs) async {
    _networkHelper =
        NetworkHelper(url: mainURL + "random?number=$numOfRecs&apiKey=$apiKey");
    var tempRecipes = await _networkHelper.getData();
    List<Recipe> recipeList = [];
    for (int i = 0; i < numOfRecs; i++) {
      recipeList.add(Recipe.fromJson(tempRecipes['recipes'][i], 1));
    }
    return recipeList;
  }
}
