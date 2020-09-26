import 'package:flutter/material.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/recipe.dart';

class RecipeEvent {
  final RecEventType eventType;
  final Recipe recipe;

  RecipeEvent({@required this.recipe, @required this.eventType});
}
