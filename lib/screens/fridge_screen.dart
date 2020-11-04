import 'dart:async';
import 'package:bordered_text/bordered_text.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/networking/recipe_provider.dart';

bool _userHasFridge = false;

int _countOfIngsToRetrieve = 11;

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  TextEditingController _controller;
  MasterBloc masterBloc;
  String _recipeToSearchFor = "";
  TextEditingController _ingAmountTextController;
  StreamSubscription<RecipeEvent> streamSubscription;
  String dropdownValue = "Kg";

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

  void getRandomIngs() async {
    List<Ingredient> list = await masterBloc.getIngs();
    randomIngList = [];
    list.shuffle();
    for (int i = 0; i < _countOfIngsToRetrieve; i++) {
      setState(() {
        randomIngList.add(list[i]);
      });
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
    WidgetsBinding.instance.addPostFrameCallback((_) => getRandomIngs());
    streamSubscription =
        masterBloc.registerToRecStreamController(recNotificationReceived);
    _controller = TextEditingController();
    _ingAmountTextController = TextEditingController();
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _floatingActionButtonAlertDialog(),
      ),
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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "What did you cook today?",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 8,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Column(
                  children: listOfRecipes.isEmpty
                      ? []
                      : [
                          HorizontalRecipeCard(
                              recipe: listOfRecipes[0],
                              onPress: () {
                                _recipeClickAlertDialog(0);
                              }),
                          HorizontalRecipeCard(
                              recipe: listOfRecipes[1],
                              onPress: () {
                                _recipeClickAlertDialog(1);
                              }),
                          HorizontalRecipeCard(
                              recipe: listOfRecipes[2],
                              onPress: () {
                                _recipeClickAlertDialog(2);
                              }),
                        ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Did you buy any groceries?",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 8,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _countOfIngsToRetrieve,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 4
                      : 8),
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () => _ingClickAlertDialog(index),
                    child: GridTile(
                      footer: GridTileBar(
                        title: Container(
                          child: BorderedText(
                            strokeColor: Colors.black,
                            strokeWidth: 3,
                            child: Text(
                              randomIngList[index].name,
                            ),
                          ),
                        ),
                      ),
                      child: getImageURL(randomIngList[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _ingClickAlertDialog(int index) {
    showDialog(
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text(randomIngList[index].name),
            content: StatefulBuilder(
              builder: (context, _setState) {
                return Container(
                  width: MediaQuery.of(context).size.width - 250,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingAmountTextController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            //TODO store amount in db
                            double num;
                            try {
                              num = double.parse(value);
                            } catch (e) {
                              num = -1;
                              print(e);
                            }
                            switch (value) {
                              case "Number":
                                randomIngList[index].nQuantity = num;
                                masterBloc.updateIng(randomIngList[index]);
                                break;
                              case "Kg":
                                randomIngList[index].kgQuantity = num;
                                masterBloc.updateIng(randomIngList[index]);
                                break;
                              case "Lr":
                                randomIngList[index].lrQuantity = num;
                                masterBloc.updateIng(randomIngList[index]);
                                break;
                              default:
                                break;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.expand_more),
                          iconSize: 15,
                          elevation: 5,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            _setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Kg', 'Number', 'Lr']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }).then((value) {
      // do something here
    });
  }

  void _recipeClickAlertDialog(int index) {
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

  _floatingActionButtonAlertDialog() {
    return DropDownField();
  }
}
