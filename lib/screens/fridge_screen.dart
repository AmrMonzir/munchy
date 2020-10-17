import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/networking/recipe_provider.dart';

bool _userHasFridge = false;

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  TextEditingController _controller;
  MasterBloc masterBloc;
  String _recipeToSearchFor = "";
  StreamSubscription<RecipeEvent> streamSubscription;
  List<Ingredient> randomIngList = [
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
  ];
  List<Widget> ingColumnChildren = [Expanded(child: Container())];

  List<Recipe> listOfRecipes = [
    Recipe(title: "loading"),
    Recipe(title: "loading"),
    Recipe(title: "loading")
  ];

  void recNotificationReceived(RecipeEvent event) {
    if (event.eventType == RecEventType.delete) {
      getTop3FavoriteRecipes();
    }
  }

  Widget getImageURL(Ingredient ingObject) {
    try {
      return Image(
        image: NetworkImage(ingObject.image.toString().trim()),
        height: 80,
        width: 80,
      );
    } catch (e) {
      return Image(
        image: AssetImage("images/placeholder_food.png"),
        height: 80,
        width: 80,
      );
    }
  }

  void get3RandomIngs() async {
    List<Ingredient> list = await masterBloc.getIngs();
    list.shuffle();
    for (int i = 0; i < 3; i++) {
      randomIngList.add(list[i]);
    }
  }

  void getTop3FavoriteRecipes() async {
    List<Recipe> nn = [];
    nn = await masterBloc.getFavoriteRecs(count: 3);
    listOfRecipes = [];
    setState(() {
      listOfRecipes.addAll(nn);
    });
    int recipesToGet = 3 - listOfRecipes.length;
    if (recipesToGet > 0) {
      RecipeProvider recipeProvider = new RecipeProvider();
      nn = await recipeProvider.getRandomRecipesData(recipesToGet);
      setState(() {
        listOfRecipes.addAll(nn);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getTop3FavoriteRecipes());
    WidgetsBinding.instance.addPostFrameCallback((_) => get3RandomIngs());
    streamSubscription =
        masterBloc.registerToRecStreamController(recNotificationReceived);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text("My fridge"),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "What did you cook today?",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              HorizontalRecipeCard(
                  recipe: listOfRecipes[0],
                  onPress: () {
                    _alertDialog(0);
                  }),
              HorizontalRecipeCard(
                  recipe: listOfRecipes[1],
                  onPress: () {
                    _alertDialog(1);
                  }),
              HorizontalRecipeCard(
                  recipe: listOfRecipes[2],
                  onPress: () {
                    _alertDialog(2);
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Did you buy any groceries?",
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Divider(),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      randomIngList[0].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: getImageURL(randomIngList[0]),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      randomIngList[1].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: getImageURL(randomIngList[1]),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      randomIngList[2].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: getImageURL(randomIngList[2]),
                  ),
                  Divider(),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _alertDialog(int index) {
    List<Ingredient> listOfIngs = listOfRecipes[index].ingredientsList;
    List<CheckboxListTile> listOfTiles = [];
    Map<Ingredient, bool> ingChecked = new Map();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text("Do you want to subtract ingredients from your fridge?"),
            content: Container(
              height: 600,
              width: 400,
              child: ListView.builder(
                itemCount: listOfIngs.length,
                itemBuilder: (context, ingIndex) {
                  ingChecked[listOfIngs[ingIndex]] = true;
                  double quantity =
                      listOfRecipes[index].ingredientsList[ingIndex].nQuantity;
                  int possibleQuantity = -1;
                  int decPoint = quantity.toString().indexOf(".");
                  if (quantity.toString()[decPoint + 1] == "0") {
                    possibleQuantity = quantity.floor();
                  }
                  return StatefulBuilder(builder: (context, _setState) {
                    return CheckboxListTile(
                      value: ingChecked[listOfIngs[ingIndex]],
                      // TODO change to reflect whether or not it should be deleted from db
                      onChanged: (value) {
                        //same as above TODO
                        _setState(() {
                          ingChecked[listOfIngs[ingIndex]] =
                              !ingChecked[listOfIngs[ingIndex]];
                        });
                      },
                      title: Text(
                          "${possibleQuantity == -1 ? quantity.toStringAsFixed(3) : possibleQuantity.toString()} ${listOfRecipes[index].ingredientsList[ingIndex].unit} of ${listOfRecipes[index].ingredientsList[ingIndex].name}"),
                      activeColor: kPrimaryColor,
                    );
                  });
                },
              ),
            ),
            actions: [
              RaisedButton(
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(),
                color: kPrimaryColor,
              ),
              RaisedButton(
                child: Text("Yes"),
                onPressed: () {
                  //TODO subtract ingredients from the user's fridge in here.
                  List<Ingredient> listOfIngsToReturn = [];
                  ingChecked.forEach((key, value) {
                    if (!value) {
                      listOfIngsToReturn.add(key);
                    }
                  });
                  // Now I have a list of ingredients to subtract from database
                  // TODO remove that list of ings from database

                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
            ],
          );
        });
  }
}
