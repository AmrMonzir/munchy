import 'package:flutter/material.dart';
import 'package:munchy/model/recipe_instructions.dart' as step;

class RecipeIngredientsCard extends StatelessWidget {
  final String name;
  final String image;

  RecipeIngredientsCard({this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            image != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image(
                      image: NetworkImage(image.toString().trim()),
                      height: 60,
                      width: 60,
                    ),
                  )
                : Container(),
            Padding(
              child: name.toString().length >= 25
                  ? Text(
                      name,
                      style: TextStyle(fontSize: 13),
                    )
                  : Text(
                      name,
                      style: TextStyle(fontSize: 16),
                    ),
              padding: EdgeInsets.only(left: 8),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        )
      ],
    );
  }
}
