import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({this.onPress, this.imagePath, this.recipeName});

  final String recipeName;
  final AssetImage imagePath;
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        constraints: BoxConstraints(
            maxHeight: 50, maxWidth: MediaQuery.of(context).size.width / 2),
        child: ListTile(
          leading: Image(
            image: imagePath,
            width: 40,
            height: 40,
          ),
          title: Text(
            recipeName,
          ),
        ),
      ),
    );
  }
}
