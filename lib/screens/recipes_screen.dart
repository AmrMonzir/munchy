import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/components/ings_widget.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';

class RecipesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Recipes Screen"),
    );
  }
}
