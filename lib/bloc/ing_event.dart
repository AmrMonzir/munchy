import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/model/ingredient.dart';

class IngredientEvent {
  final IngEventType eventType;
  final Ingredient ingredient;

  IngredientEvent({@required this.ingredient, @required this.eventType});
}
