import 'dart:io';
import 'package:bordered_text/bordered_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/helpers/recipe_provider.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ingredientDao = IngredientsDao();
  MasterBloc masterBloc;
  String welcomeText = "Have you had breakfast yet?";
  FirebaseHelper firebaseHelper;
  List<Recipe> recipesToDisplay = [];
  ScrollController _categoryListController;
  String errorText = "Choose a category to suggest recipes you can make!";
  String chosenTag = "";
  Recipe healthyRec;

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    firebaseHelper = FirebaseHelper();
    firebaseHelper.syncOnlineIngsToLocal(context);
    getRandomRecipesIHaveIngsFor();
    editWelcomeText();
    getHealthyRecipeOfTheDay();
  }

  Future<void> getHealthyRecipeOfTheDay() async {
    RecipeProvider recipeProvider = RecipeProvider();
    var rec = await recipeProvider.getRandomHealthyRecipe();
    setState(() {
      healthyRec = rec;
    });
  }

  Future<void> getRandomRecipesIHaveIngsFor() async {
    RecipeProvider recipeProvider = RecipeProvider();

    List<Ingredient> l = await masterBloc.getLocalIngs(columns: ["name"]);
    List<String> ingNames = [];

    if (l.isNotEmpty) {
      l.shuffle();
      for (var ing in l) {
        ingNames.add(ing.name);
      }
      List<Recipe> recipes = [];
      if (chosenTag == "")
        recipes = await recipeProvider.getRecipesWithIngs(ingNames, 4);
      else
        recipes = await recipeProvider.getRecipesWithIngs(ingNames, 4,
            recipeType: chosenTag);
      setState(() {
        recipesToDisplay = recipes;
      });
    } else {
      setState(() {
        recipesToDisplay = [];
        errorText =
            "You have no ingredients yet!\n Add some ingredients through the fridge or the local ingredients settings pages";
      });
    }
  }

  ImageProvider getRecImageUrl(Recipe recipe) {
    if (recipe.image != null) {
      if (recipe.image.contains("files/Pictures") ||
          recipe.image.contains("image_picker"))
        return FileImage(File(recipe.image));
      else
        return NetworkImage(recipe.image);
    } else
      return AssetImage("images/placeholder_food.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Image.asset(
                'images/appBarLogo.png',
                height: 60,
                width: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Munchy",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Text(
                welcomeText,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _categoryListController,
              itemCount: kCategoriesList.length,
              itemBuilder: (context, itemIndex) {
                if (itemIndex == 0) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "You can make",
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      CategoryWidget(
                        text: kCategoriesList[itemIndex],
                        onPress: () {
                          setState(() {
                            chosenTag = kCategoriesList[itemIndex];
                          });
                          getRandomRecipesIHaveIngsFor();
                        },
                      ),
                    ],
                  );
                } else {
                  return CategoryWidget(
                    text: kCategoriesList[itemIndex],
                    onPress: () {
                      setState(() {
                        chosenTag = kCategoriesList[itemIndex];
                      });
                      getRandomRecipesIHaveIngsFor();
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 8),
          recipesToDisplay.isNotEmpty
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: recipesToDisplay.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Hero(
                          tag: recipesToDisplay.indexOf(i).toString(),
                          child: MaterialButton(
                            onPressed: () => pushNewScreen(context,
                                screen: RecipeScreen(
                                    recipe: i,
                                    indexForHero: recipesToDisplay.indexOf(i)),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[700],
                                    blurRadius: 1.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                                image: DecorationImage(
                                    image: getRecImageUrl(i),
                                    fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, right: 10),
                                  child: BorderedText(
                                    strokeWidth: 3,
                                    strokeColor: Colors.black,
                                    child: Text(
                                      i.title,
                                      style: TextStyle(
                                          fontSize: 27.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorText,
                    style: kTextStylePoppins,
                  ),
                )),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: kDividerColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.add_circle_rounded,
                color: Colors.green,
                size: 38,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  "Healthy recipe of the day",
                  style: kTextStylePoppins.copyWith(
                      fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: healthyRec == null
                ? Center(
                    child: Text(
                      "Loading a Healthy Recipe for you!",
                      style: kTextStylePoppins.copyWith(fontSize: 20),
                    ),
                  )
                : HealthyRecipeWidget(recipe: healthyRec),
          )
        ],
      ),
    );
  }

  void editWelcomeText() {
    DateTime now = DateTime.now();

    if (now.hour >= 6 && now.hour < 12) {
      setState(() {
        welcomeText = "Have you had breakfast yet?";
      });
    } else if (now.hour >= 12 && now.hour < 18) {
      setState(() {
        welcomeText = "Have you had lunch yet?";
      });
    } else if (now.hour >= 18 && now.hour < 23) {
      setState(() {
        welcomeText = "Have you had dinner yet?";
      });
    } else {
      setState(() {
        welcomeText = "Up for a midnight snack?";
      });
    }
  }
}

class HealthyRecipeWidget extends StatelessWidget {
  final Recipe recipe;

  const HealthyRecipeWidget({Key key, this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Hero(
      tag: "134134",
      child: MaterialButton(
        onPressed: () {
          pushNewScreen(context,
              screen: RecipeScreen(
                recipe: recipe,
                indexForHero: 134134,
              ),
              pageTransitionAnimation: PageTransitionAnimation.fade);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 2,
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: screenHeight / 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.0,
                          spreadRadius: 0.0,
                          offset: Offset(0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: NetworkImage(recipe.image), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      recipe.title,
                      style: kTextStylePoppins.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money,
                                color: recipe.cheap
                                    ? Colors.green
                                    : kPrimaryColor),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              recipe.cheap ? "Cheap" : "Not cheap",
                              style: kTextStylePoppins.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              recipe.healthScore.toString() + "%",
                              style: kTextStylePoppins.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String text;
  final onPress;

  const CategoryWidget({Key key, this.text, this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          onPressed: onPress,
          color: kAccentColor,
          child: BorderedText(
            strokeWidth: 0.1,
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: Colors.white),
            ),
          ),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
