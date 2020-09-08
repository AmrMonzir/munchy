import 'package:flutter/material.dart';

class RecipesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Recipes Screen"),
    );
  }
}
