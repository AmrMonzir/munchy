import 'package:flutter/material.dart';

class RecipeIngredientsCard extends StatelessWidget {
  final String name;
  final String image;
  final String amount;

  RecipeIngredientsCard({this.name, this.image, this.amount});

  ImageProvider getImage() {
    try {
      return NetworkImage(image.toString().trim());
    } catch (e) {
      return AssetImage("images/placeholder_food.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                image != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image(
                          image: getImage(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                amount,
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.grey[500],
        )
      ],
    );
  }
}
