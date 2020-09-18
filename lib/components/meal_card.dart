import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final AssetImage image;
  final String text;
  final double safeAreaHeight;

  MealCard({this.text, this.image, this.safeAreaHeight});

  @override
  Widget build(BuildContext context) {
    // var safePadding = MediaQuery.of(context).padding.top;
    // print(safePadding);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Container(
        height: safeAreaHeight / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: Colors.grey),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
