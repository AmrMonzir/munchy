import 'package:flutter/material.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//TODO change this shitty card to something more elegant

class HorizontalRecipeCard extends StatelessWidget {
  HorizontalRecipeCard({this.recipe, this.onPress});
  final onPress;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
            child: Container(
              child: ListTile(
                leading: Image(
                  image: NetworkImage(recipe.image),
                  width: 80,
                  height: 80,
                ),
                title: Text(
                  recipe.title,
                  style: TextStyle(fontSize: 20),
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
