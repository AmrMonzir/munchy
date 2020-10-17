import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchy/model/recipe.dart';

class HorizontalRecipeCard extends StatelessWidget {
  HorizontalRecipeCard({this.recipe, this.onPress});
  final onPress;
  final Recipe recipe;

  Widget getImageUrl() {
    if (!recipe.image.contains("image_picker"))
      return Image.network(recipe.image,
          fit: BoxFit.fitWidth, width: 80, height: 80);
    try {
      return Image.file(File(recipe.image),
          fit: BoxFit.fitWidth, width: 80, height: 80);
    } catch (e) {
      return Image.asset("images/placeholder_food.png",
          fit: BoxFit.fitWidth, width: 80, height: 80);
    }
  }

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
                leading: getImageUrl(),
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
