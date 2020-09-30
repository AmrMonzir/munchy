import 'dart:convert';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe_instructions.dart';

Recipe recipeFromJson(String str, int caller) =>
    Recipe.fromJson(json.decode(str), caller);

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  Recipe(
      {this.id,
      this.title,
      this.image,
      this.servings,
      this.readyInMinutes,
      this.sourceName,
      this.spoonacularSourceUrl,
      this.healthScore,
      this.analyzedInstructions,
      this.cheap,
      this.summary,
      this.dishTypes,
      this.ingredientsList,
      this.isFavorite});

  int id;
  String title;
  String image;
  int servings;
  int readyInMinutes;
  String sourceName;
  String spoonacularSourceUrl;
  double healthScore;
  List<RecipeInstructions> analyzedInstructions;
  bool cheap;
  List<String> dishTypes;
  List<Ingredient> ingredientsList;
  String summary;
  bool isFavorite = false;

  factory Recipe.fromJson(Map<String, dynamic> json, int caller) {
    //caller is database
    if (caller == 0)
      return Recipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        servings: json["servings"],
        readyInMinutes: json["readyInMinutes"],
        sourceName: json["sourceName"],
        spoonacularSourceUrl: json["spoonacularSourceUrl"],
        healthScore: json["healthScore"],
        analyzedInstructions: List<RecipeInstructions>.from(
            jsonDecode(json["analyzedInstructions"])
                .map((x) => RecipeInstructions.fromJson(x))),
        cheap: json["cheap"] == 0 ? false : true,
        dishTypes:
            List<String>.from(jsonDecode(json["dishTypes"]).map((x) => x)),
        ingredientsList: List<Ingredient>.from(
            jsonDecode(json["extendedIngredients"])
                .map((x) => Ingredient.fromDatabaseJson(x))),
        summary: json["summary"],
        isFavorite: json["is_favorite"] == 0 ? false : true,
      );
    else
      return Recipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        servings: json["servings"],
        readyInMinutes: json["readyInMinutes"],
        sourceName: json["sourceName"],
        spoonacularSourceUrl: json["spoonacularSourceUrl"],
        healthScore: json["healthScore"],
        analyzedInstructions: List<RecipeInstructions>.from(
            json["analyzedInstructions"]
                .map((x) => RecipeInstructions.fromJson(x))),
        cheap: json["cheap"] == 0 ? false : true,
        dishTypes: List<String>.from(json["dishTypes"].map((x) => x)),
        ingredientsList: List<Ingredient>.from(json["extendedIngredients"]
            .map((x) => Ingredient.fromDatabaseJson(x))),
        summary: json["summary"],
        //when first getting from api isFavorite is sure to be false
        isFavorite: false,
      );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "servings": servings,
        "readyInMinutes": readyInMinutes,
        "sourceName": sourceName,
        "spoonacularSourceUrl": spoonacularSourceUrl,
        "healthScore": healthScore,
        "analyzedInstructions":
            jsonEncode(List<dynamic>.from(analyzedInstructions.map((x) => x))),
        "cheap": cheap,
        "dishTypes":
            jsonEncode(List<dynamic>.from(dishTypes.map((x) => x))).toString(),
        "extendedIngredients": jsonEncode(List<dynamic>.from(
            ingredientsList.map((x) => x.toDatabaseJson()))).toString(),
        "summary": summary,
        "is_favorite": this.isFavorite == false ? 0 : 1,
      };
}
