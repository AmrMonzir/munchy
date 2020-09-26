import 'package:flutter/material.dart';

//TODO change this shitty card to something more elegant

class RecipeCard extends StatelessWidget {
  RecipeCard({this.onPress, this.imagePath, this.recipeName});

  final String recipeName;
  final AssetImage imagePath;
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
          child: Container(
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
        ),
        Divider(),
      ],
    );
  }
}
