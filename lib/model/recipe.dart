import 'dart:convert';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe_instructions.dart';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

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

  int id; //
  String title; //
  String image; //
  int servings; //
  int readyInMinutes; //
  String sourceName;
  String spoonacularSourceUrl; //
  double healthScore; //
  List<dynamic> analyzedInstructions; //
  bool cheap; //
  List<String> dishTypes; //
  List<Ingredient> ingredientsList; //
  String summary; //
  bool isFavorite; //

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        servings: json["servings"],
        readyInMinutes: json["readyInMinutes"],
        sourceName: json["sourceName"],
        spoonacularSourceUrl: json["spoonacularSourceUrl"],
        healthScore: json["healthScore"],
        analyzedInstructions:
            List<dynamic>.from(json["analyzedInstructions"].map((x) => x)),
        cheap: json["cheap"],
        dishTypes: List<String>.from(json["dishTypes"].map((x) => x)),
        ingredientsList: List<Ingredient>.from(json["extendedIngredients"]
            .map((x) => Ingredient.fromDatabaseJson(x))),
        summary: json["summary"],
        isFavorite: json["is_favorite"] == 0 ? false : true,
      );

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
            List<dynamic>.from(analyzedInstructions.map((x) => x)).toString(),
        "cheap": cheap,
        "dishTypes": List<dynamic>.from(dishTypes.map((x) => x)).toString(),
        "extendedIngredients":
            ingredientsList.map((x) => x.toDatabaseJson()).toString(),
        "summary": summary,
        "is_favorite": isFavorite,
      };
}
