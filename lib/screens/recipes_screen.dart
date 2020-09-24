import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:munchy/networking/network_helper.dart';

const String apiKey = "f2007f6cd6b0479eacff63b69ec08ebd";
const String mainURL = "https://api.spoonacular.com/recipes/";

class RecipesScreen extends StatelessWidget {
  final String category;
  RecipesScreen({this.category});

  var networkHelper =
      NetworkHelper(url: mainURL + "random?number=1&apiKey=$apiKey");
  var recipeList;
  Future<List<Recipe>> getRecipesData() async {
    recipeList = await networkHelper.getData();
    // print(recipeList);
    var recipe = Recipe.fromJson(recipeList);
    print(recipe.summary);
  }

  Widget imageByCategory() {
    switch (category) {
      case "Breakfast":
        return ImageWithLabel(
            category: category, image: AssetImage("images/breakfast.jpg"));
        break;
      case "Lunch":
        return ImageWithLabel(
            category: category, image: AssetImage("images/lunch.jpg"));
        break;
      case "Dinner":
        return ImageWithLabel(
            category: category, image: AssetImage("images/dinner.jpg"));
        break;
      default:
        return ImageWithLabel(
            category: category, image: AssetImage("images/breakfast.jpg"));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getRecipesData();
        },
      ),
      backgroundColor: kScaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              snap: false,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: imageByCategory(),
                  )
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300.0,
                // mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return RecipeCard(
                    index: index,
                    onPress: () {
                      //TODO push to recipe screen
                      pushNewScreen(
                        context,
                        screen: RecipeScreen(
                          recipeName: "Sample recipe name",
                          image: AssetImage("placeholder_food.png"),
                          indexForHero: index,
                        ),
                      );
                    },
                  );
                },
                childCount: 5,
              ),
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  RecipeCard({this.index, this.onPress});
  final int index;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Hero(
        tag: index.toString(),
        child: Card(
          margin: EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/placeholder_food.png"),
                  fit: BoxFit.fitWidth),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: BorderedText(
                strokeWidth: 3,
                strokeColor: Colors.black,
                child: Text(
                  "Recipe Name",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageWithLabel extends StatelessWidget {
  ImageWithLabel({this.category, this.image});

  final String category;
  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: category,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
        child: Container(
          child: BorderedText(
            // strokeWidth: 1,
            child: Text(
              category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: "Lobster",
              ),
            ),
          ),
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(left: 10, bottom: 10),
        ),
      ),
    );
  }
}
