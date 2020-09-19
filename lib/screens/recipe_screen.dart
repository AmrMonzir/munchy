import 'package:flutter/material.dart';
import 'package:munchy/constants.dart';

class RecipeScreen extends StatelessWidget {
  static String id = "recipe_screen";
  final String recipeName;
  final AssetImage image;
  final int indexForHero;

  RecipeScreen({@required this.recipeName, this.image, this.indexForHero});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: kScaffoldBackgroundColor,
              expandedHeight: height * 2 / 3,
              collapsedHeight: height / 4,
              floating: false,
              pinned: true,
              snap: false,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Hero(
                        tag: indexForHero.toString(),
                        child: Image.asset(
                          "images/placeholder_food.png",
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
