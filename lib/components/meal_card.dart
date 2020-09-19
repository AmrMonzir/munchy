import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final AssetImage image;
  final String text;
  final onPress;
  // final double safeAreaHeight;

  MealCard({this.text, this.image, this.onPress});

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 91;
    // var safePadding = MediaQuery.of(context).padding.top;
    // print(safePadding);
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Hero(
          tag: text,
          child: Container(
            height: height / 3,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: Offset(1, 1),
                )
              ],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
            child: Container(
              child: BorderedText(
                // strokeWidth: 1,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lobster",
                  ),
                ),
              ),
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 15, bottom: 15),
            ),
          ),
        ),
      ),
    );
  }
}
