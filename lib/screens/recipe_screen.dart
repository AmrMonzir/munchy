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
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "images/placeholder_food.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: new EdgeInsets.all(16.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    TabBar(
                      onTap: (index) {
                        if (index == 0) {
                          //TODO fetch recipe ingredients (from init state actually)
                          //display recipe ingredients in the bottom container
                        } else if (index == 1) {
                          //display recipe steps in the bottom container
                        }
                      },
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Icon(Icons.menu), text: "Ingredients"),
                        Tab(
                            icon: Icon(Icons.restaurant_menu),
                            text: "Preparation Steps"),
                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: Container(),
        ),
      ),
    );
  }
}
