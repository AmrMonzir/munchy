import 'package:flutter/material.dart';
import 'package:munchy/objects/ingredient.dart';

class Recipe {
  String name;
  String id;
  Image imageURL;
  List<Ingredient> listOfAllIngredients = [];

  Recipe({this.name, this.id, this.imageURL, this.listOfAllIngredients});
}
