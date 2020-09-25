import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:munchy/components/rounded_button.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:munchy/networking/network_helper.dart';

const String apiKey = "f2007f6cd6b0479eacff63b69ec08ebd";
const String mainURL = "https://api.spoonacular.com/recipes/";

int _numOfRecipesToRetrieve;

class RecipesScreen extends StatefulWidget {
  final String category;
  RecipesScreen({this.category});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  var networkHelper = NetworkHelper(
      url: mainURL + "random?number=$_numOfRecipesToRetrieve&apiKey=$apiKey");
  ScrollController _controller;

  List<Recipe> recipeList = [];

  Future<List<Recipe>> getRecipesData() async {
    var tempRecipes = await networkHelper.getData();
    for (int i = 0; i < _numOfRecipesToRetrieve; i++) {
      setState(() {
        recipeList.add(Recipe.fromJson(tempRecipes['recipes'][i]));
      });
    }
    return recipeList;
  }

  Widget imageByCategory() {
    switch (widget.category) {
      case "Breakfast":
        return ImageWithLabel(
            category: widget.category,
            image: AssetImage("images/breakfast.jpg"));
        break;
      case "Lunch":
        return ImageWithLabel(
            category: widget.category, image: AssetImage("images/lunch.jpg"));
        break;
      case "Dinner":
        return ImageWithLabel(
            category: widget.category, image: AssetImage("images/dinner.jpg"));
        break;
      default:
        return ImageWithLabel(
            category: widget.category,
            image: AssetImage("images/breakfast.jpg"));
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    _numOfRecipesToRetrieve = 2;
    WidgetsBinding.instance.addPostFrameCallback((_) => getRecipesData());
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels != 0) {
          _updateUI();
        }
      }
    });
  }

  void _updateUI() {
    setState(() {
      _numOfRecipesToRetrieve += 3;
    });
    getRecipesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: NestedScrollView(
        controller: _controller,
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
                    recipeName: recipeList[index].title,
                    image: NetworkImage(recipeList[index].image),
                    index: index,
                    onPress: () {
                      pushNewScreen(
                        context,
                        screen: RecipeScreen(
                          recipe: recipeList[index],
                          indexForHero: index,
                        ),
                      );
                    },
                  );
                },
                childCount: _numOfRecipesToRetrieve,
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
  RecipeCard(
      {@required this.index,
      this.onPress,
      @required this.image,
      @required this.recipeName});
  final int index;
  final onPress;
  final NetworkImage image;
  final String recipeName;
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
              image: DecorationImage(image: image, fit: BoxFit.fitHeight),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: BorderedText(
                strokeWidth: 3,
                strokeColor: Colors.black,
                child: Text(
                  recipeName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
