import 'dart:convert';

List<RecipeInstructions> recipeInstructionsFromJson(String str) =>
    List<RecipeInstructions>.from(
        json.decode(str).map((x) => RecipeInstructions.fromJson(x)));

String recipeInstructionsToJson(List<RecipeInstructions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipeInstructions {
  RecipeInstructions({
    this.name,
    this.steps,
  });

  String name;
  List<Step> steps;

  factory RecipeInstructions.fromJson(Map<String, dynamic> json) =>
      RecipeInstructions(
        name: json["name"],
        steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
      };
}

class Step {
  Step({
    this.equipment,
    this.ingredients,
    this.number,
    this.step,
    this.length,
  });

  List<Ent> equipment;
  List<Ent> ingredients;
  int number;
  String step;
  Length length;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        equipment:
            List<Ent>.from(json["equipment"].map((x) => Ent.fromJson(x))),
        ingredients:
            List<Ent>.from(json["ingredients"].map((x) => Ent.fromJson(x))),
        //TODO fix number problem if steps are double "double is not a subtype of int"
        number: json["number"],
        step: json["step"],
        length: json["length"] == null ? null : Length.fromJson(json["length"]),
      );

  Map<String, dynamic> toJson() => {
        "equipment": List<dynamic>.from(equipment.map((x) => x.toJson())),
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
        "number": number,
        "step": step,
        "length": length == null ? null : length.toJson(),
      };
}

class Ent {
  Ent({
    this.id,
    this.image,
    this.name,
    this.temperature,
  });

  int id;
  String image;
  String name;
  Length temperature;

  factory Ent.fromJson(Map<String, dynamic> json) => Ent(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        temperature: json["temperature"] == null
            ? null
            : Length.fromJson(json["temperature"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "temperature": temperature == null ? null : temperature.toJson(),
      };
}

class Length {
  Length({
    this.number,
    this.unit,
  });

  String number;
  String unit;

  factory Length.fromJson(Map<String, dynamic> json) => Length(
        number: json["number"].toString(),
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "unit": unit,
      };
}
