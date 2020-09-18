import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/components/ings_widget.dart';
import 'package:munchy/components/meal_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';

class RecipesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: TextField(
          decoration: kSearchTextFieldDecoration.copyWith(
              hintText: "Search for recipe..."),
        ),
      ),
      body: SafeArea(
        child: new LayoutBuilder(builder: (context, constraints) {
          return ListView(
            children: [
              MealCard(
                image: AssetImage("images/breakfast.jpg"),
                text: "Breakfast",
                safeAreaHeight: constraints.maxHeight,
              ),
              MealCard(
                image: AssetImage("images/lunch.jpg"),
                text: "Lunch",
                safeAreaHeight: constraints.maxHeight,
              ),
              MealCard(
                image: AssetImage("images/dinner.jpg"),
                text: "Dinner",
                safeAreaHeight: constraints.maxHeight,
              ),
            ],
          );
        }),
      ),
    );
  }
}
/*child: Column(
          children: [
            MealCard(
              image: AssetImage("images/breakfast.jpg"),
              text: "Breakfast",
            ),
            MealCard(
              image: AssetImage("images/lunch.jpg"),
              text: "Lunch",
            ),
            MealCard(
              image: AssetImage("images/dinner.jpg"),
              text: "Dinner",
            ),
          ],
        ),*/
