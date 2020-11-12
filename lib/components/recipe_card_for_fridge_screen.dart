import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchy/model/recipe.dart';

class HorizontalRecipeCard extends StatelessWidget {
  HorizontalRecipeCard({this.recipe, this.onPress});
  final onPress;
  final Recipe recipe;

  Widget getImageUrl() {
    if (recipe.image != null) {
      if (recipe.image.contains("files/Pictures") ||
          recipe.image.contains("image_picker"))
        return Image.file(File(recipe.image),
            fit: BoxFit.fitWidth, width: 80, height: 80);
      else
        return Image.network(recipe.image,
            fit: BoxFit.fitWidth, width: 80, height: 80);
    } else
      return Image.asset("images/placeholder_food.png",
          fit: BoxFit.fitWidth, width: 80, height: 80);
  }

  ImageProvider getRecImageUrl(Recipe recipe) {
    if (recipe.image != null) {
      if (recipe.image.contains("files/Pictures") ||
          recipe.image.contains("image_picker"))
        return FileImage(File(recipe.image));
      else
        return NetworkImage(recipe.image);
    } else
      return AssetImage("images/placeholder_food.png");
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
