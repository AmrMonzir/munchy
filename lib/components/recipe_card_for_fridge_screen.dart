import 'package:flutter/material.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//TODO change this shitty card to something more elegant

class RecipeCard extends StatelessWidget {
  RecipeCard({this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: RecipeScreen(recipe: recipe));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
            child: Container(
              child: ListTile(
                leading: Image(
                  image: NetworkImage(recipe.image),
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  recipe.title,
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
