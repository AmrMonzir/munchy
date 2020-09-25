import 'dart:convert';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe_instructions.dart';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  Recipe({
    this.id,
    this.title,
    this.image,
    this.imageType,
    this.servings,
    this.readyInMinutes,
    this.sourceName,
    this.spoonacularSourceUrl,
    this.healthScore,
    this.analyzedInstructions,
    this.cheap,
    this.creditsText,
    this.instructions,
    this.sustainable,
    this.vegan,
    this.vegetarian,
    this.veryHealthy,
    this.veryPopular,
    this.whole30,
    this.summary,
    this.weightWatcherSmartPoints,
    this.dishTypes,
    this.ingredientsList,
  });

  int id;
  String title;
  String image;
  String imageType;
  int servings;
  int readyInMinutes;
  String sourceName;
  String spoonacularSourceUrl;
  double healthScore;
  List<dynamic> analyzedInstructions;
  bool cheap;
  String creditsText;
  String instructions;
  bool sustainable;
  bool vegan;
  bool vegetarian;
  bool veryHealthy;
  bool veryPopular;
  bool whole30;
  int weightWatcherSmartPoints;
  List<String> dishTypes;
  List<Ingredient> ingredientsList;
  String summary;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        imageType: json["imageType"],
        servings: json["servings"],
        readyInMinutes: json["readyInMinutes"],
        sourceName: json["sourceName"],
        spoonacularSourceUrl: json["spoonacularSourceUrl"],
        healthScore: json["healthScore"],
        analyzedInstructions:
            List<dynamic>.from(json["analyzedInstructions"].map((x) => x)),
        cheap: json["cheap"],
        creditsText: json["creditsText"],
        instructions: json["instructions"],
        sustainable: json["sustainable"],
        vegan: json["vegan"],
        vegetarian: json["vegetarian"],
        veryHealthy: json["veryHealthy"],
        veryPopular: json["veryPopular"],
        whole30: json["whole30"],
        weightWatcherSmartPoints: json["weightWatcherSmartPoints"],
        dishTypes: List<String>.from(json["dishTypes"].map((x) => x)),
        ingredientsList: List<Ingredient>.from(json["extendedIngredients"]
            .map((x) => Ingredient.fromDatabaseJson(x))),
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "imageType": imageType,
        "servings": servings,
        "readyInMinutes": readyInMinutes,
        "sourceName": sourceName,
        "spoonacularSourceUrl": spoonacularSourceUrl,
        "healthScore": healthScore,
        "analyzedInstructions":
            List<dynamic>.from(analyzedInstructions.map((x) => x)),
        "cheap": cheap,
        "creditsText": creditsText,
        "instructions": instructions,
        "sustainable": sustainable,
        "vegan": vegan,
        "vegetarian": vegetarian,
        "veryHealthy": veryHealthy,
        "veryPopular": veryPopular,
        "whole30": whole30,
        "weightWatcherSmartPoints": weightWatcherSmartPoints,
        "dishTypes": List<dynamic>.from(dishTypes.map((x) => x)),
        "extendedIngredients": List<Ingredient>.from(
            ingredientsList.map((x) => x.toDatabaseJson())),
        "summary": summary,
      };
}
