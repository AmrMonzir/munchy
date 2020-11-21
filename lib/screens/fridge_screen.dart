import 'dart:async';
import 'dart:io';
import 'package:bordered_text/bordered_text.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/helpers/unit%20converter.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/helpers/recipe_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

int _countOfIngsToRetrieve = 0;

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  TextEditingController _dropDownFieldController;
  MasterBloc masterBloc;
  TextEditingController _ingAmountTextController;
  StreamSubscription<RecipeEvent> recStreamSubscription;
  StreamSubscription<IngredientEvent> ingStreamSubscription;
  String dropdownValue = "mg";

  List<Ingredient> listOfAllIngs = [];

  List<Ingredient> randomIngList = [
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
    Ingredient(name: "loading"),
  ];

  List<Widget> ingColumnChildren = [Expanded(child: Container())];

  List<Recipe> listOfRecipes = [];

  void recNotificationReceived(RecipeEvent event) {
    if (event.eventType == RecEventType.delete ||
        event.eventType == RecEventType.add) {
      getTop3FavoriteRecipes();
    }
  }

  void ingNotificationReceived(IngredientEvent event) {
    if (event.eventType == IngEventType.delete ||
        event.eventType == IngEventType.update) getRandomEssentialIngs();
  }

  Widget getIngImageURL(Ingredient ingObject) {
    if (ingObject.name != null) {
      try {
        return Image(
            image: NetworkImage(ingObject.image.toString().trim()),
            height: 80,
            width: 80);
      } catch (e) {
        return Image(
            image: AssetImage("images/placeholder_food.png"),
            height: 80,
            width: 80);
      }
    }
    return Container();
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

  Future<List<Ingredient>> getAllIngsForSearch() async {
    return await masterBloc.getIngs();
  }

  void getRandomEssentialIngs() async {
    List<Ingredient> list = await masterBloc.getRandomEssentialIngs();
    randomIngList = [];
    // list.shuffle();
    for (var i in list) {
      setState(() {
        randomIngList.add(i);
      });
    }
    if (randomIngList.length > 11) {
      _countOfIngsToRetrieve = 11;
    } else {
      _countOfIngsToRetrieve = randomIngList.length;
    }
  }

  void getTop3FavoriteRecipes() async {
    List<Recipe> nn = [];
    nn = await masterBloc.getFavoriteRecs();
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getRandomEssentialIngs());
    recStreamSubscription =
        masterBloc.registerToRecStreamController(recNotificationReceived);
    ingStreamSubscription =
        masterBloc.registerToIngStreamController(ingNotificationReceived);
    _dropDownFieldController = TextEditingController();
    _ingAmountTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    recStreamSubscription.cancel();
    ingStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          listOfAllIngs = await masterBloc.getIngs();
          _floatingActionButtonAlertDialog();
        },
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
          listOfRecipes.length > 0
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: listOfRecipes.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return MaterialButton(
                          onPressed: () => _recipeClickAlertDialog(i),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
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
                                    child: Text(i.title,
                                        style: TextStyle(
                                            fontSize: 27.0,
                                            color: Colors.white))),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : Text("No favorite recipes are there"),
          Divider(),
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
            child: _countOfIngsToRetrieve > 0
                ? GridView.builder(
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
                                subtitle: BorderedText(
                              strokeColor: Colors.black,
                              strokeWidth: 3,
                              child: Text(randomIngList[index].name),
                            )),
                            child: getIngImageURL(randomIngList[index]),
                          ),
                        ),
                      );
                    },
                  )
                : Text(
                    "Add ingredients to your essential list to display them here"),
          ),
        ],
      ),
    );
  }

  void _ingClickAlertDialog(int index) {
    Ingredient _currentIng = randomIngList[index];
    double amount;

    showDialog(
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text(_currentIng.name),
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
                          decoration: InputDecoration(hintText: "Enter amount"),
                          onChanged: (value) {
                            try {
                              amount = double.parse(value);
                            } catch (e) {
                              amount = -1;
                              print(e);
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
                          items: <String>['mg', 'Number', 'ml']
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
            actions: [
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  _ingAmountTextController.clear();
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
              RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  // _currentIng now has updated values as needed.
                  switch (dropdownValue) {
                    case "Number":
                      _currentIng.nQuantity = amount;
                      break;
                    case "mg":
                      _currentIng.kgQuantity = amount;
                      break;
                    case "ml":
                      _currentIng.lrQuantity = amount;
                      break;
                    default:
                      break;
                  }
                  masterBloc.updateIng(_currentIng, true);
                  _ingAmountTextController.clear();
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
            ],
          );
        }).then((value) {
      // do something here
    });
  }

  void _recipeClickAlertDialog(Recipe recipe) async {
    //get all ings for recipe, for each one, check if the amount exists in db or not
    Map<Ingredient, int> ingChecked = new Map();
    List<Ingredient> listOfIngs = [];

    //get the worthy list of ings here
    recipe.ingredientsList.forEach((ing) {
      if (UnitConverter.isUnitWorthy(ing.unit)) {
        setState(() {
          listOfIngs.add(ing);
        });
      }
    });

    // To check if each ing contents are already there in db or not
    // Will show NULL for each ing in two cases:
    // 1- Ing doesn't exist in db
    // 2- Ing exists but its amount doesn't fulfill recipe needs
    for (var ing in listOfIngs) {
      var ingEquivalent = await masterBloc.getIng(ing.id);
      // print(ingEquivalent.toString());
      //change the ing amount/unit to either kg/lr or num
      bool isAmountAvailable = false;
      if (ingEquivalent != null) {
        if (ing.unit == "") {
          isAmountAvailable = ing.amountForAPIRecipes < ingEquivalent.nQuantity;
        } else if (UnitConverter.isConvertableToMg(ing.unit)) {
          isAmountAvailable =
              UnitConverter.convertToMg(ing.unit, ing.amountForAPIRecipes) <
                  ingEquivalent.kgQuantity;
        } else {
          isAmountAvailable =
              UnitConverter.convertToMl(ing.unit, ing.amountForAPIRecipes) <
                  ingEquivalent.lrQuantity;
        }
      }
      if (!isAmountAvailable)
        ingChecked.putIfAbsent(ing, () => 0);
      else
        ingChecked.putIfAbsent(ing, () => -1);
    }

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
                  if (ingChecked[listOfIngs[ingIndex]] != 0) {
                    if (ingChecked[listOfIngs[ingIndex]] == -1) {
                      if (!(listOfIngs[ingIndex].unit == "" &&
                          listOfIngs[ingIndex].amountForAPIRecipes < 1))
                        ingChecked[listOfIngs[ingIndex]] = 1;
                    }
                  } else {
                    ingChecked[listOfIngs[ingIndex]] = -1;
                  }

                  double quantity = listOfIngs[ingIndex].amountForAPIRecipes;
                  int possibleQuantity = -1;
                  int decPoint = quantity.toString().indexOf(".");
                  if (quantity.toString()[decPoint + 1] == "0") {
                    possibleQuantity = quantity.floor();
                  }
                  int isActive = -1;
                  if (ingChecked[listOfIngs[ingIndex]] != -1) isActive = 1;

                  return StatefulBuilder(builder: (context, _setState) {
                    return CheckboxListTile(
                      activeColor: isActive == -1 ? Colors.grey : kPrimaryColor,
                      tristate: true,
                      value: ingChecked[listOfIngs[ingIndex]] == -1
                          ? null
                          : ingChecked[listOfIngs[ingIndex]] == 0
                              ? false
                              : true,
                      onChanged: (value) {
                        _setState(() {
                          if (ingChecked[listOfIngs[ingIndex]] == 0) {
                            ingChecked[listOfIngs[ingIndex]] = 1;
                          } else {
                            ingChecked[listOfIngs[ingIndex]] = 0;
                          }
                          // ingChecked[listOfIngs[ingIndex]] =
                          //     !ingChecked[listOfIngs[ingIndex]];
                        });
                      },
                      title: listOfIngs[ingIndex].unit == ""
                          ? Text(
                              "${possibleQuantity == -1 ? quantity.toStringAsFixed(3) : possibleQuantity.toString()} ${listOfIngs[ingIndex].name}")
                          : Text(
                              "${possibleQuantity == -1 ? quantity.toStringAsFixed(3) : possibleQuantity.toString()} ${listOfIngs[ingIndex].unit} of ${listOfIngs[ingIndex].name}"),
                    );
                  });
                },
              ),
            ),
            actions: [
              RaisedButton(
                child: Text("No"),
                onPressed: () {
                  _ingAmountTextController.clear();
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
              RaisedButton(
                child: Text("Yes"),
                onPressed: () async {
                  List<Ingredient> listOfIngsToSubtractFrom = [];
                  ingChecked.forEach((ing, isChecked) {
                    if (isChecked == 1) {
                      listOfIngsToSubtractFrom.add(ing);
                    }
                  });
                  // Now I have a list of ingredients to subtract from database
                  // remove that list of ings in the assigned quantities from database
                  for (var ing in listOfIngsToSubtractFrom) {
                    Ingredient dbIng = await masterBloc.getIng(ing.id);
                    if (UnitConverter.isConvertableToMg(
                        ing.unit.toLowerCase())) {
                      dbIng.kgQuantity -= UnitConverter.convertToMg(
                          ing.unit, ing.amountForAPIRecipes);
                    } else if (UnitConverter.isConvertableToMl(ing.unit)) {
                      dbIng.lrQuantity -= UnitConverter.convertToMl(
                          ing.unit, ing.amountForAPIRecipes);
                    } else if (ing.unit == "") {
                      dbIng.nQuantity -= ing.amountForAPIRecipes;
                    }
                    masterBloc.updateIng(dbIng, true);
                  }
                  _ingAmountTextController.clear();
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
            ],
          );
        });
  }

  _floatingActionButtonAlertDialog() {
    String _currentChosenIng = "";
    Ingredient ingToAddTo;
    double num;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, _setState) {
              return AlertDialog(
                title: Text("What did you buy?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: DropDownField(
                        strict: false,
                        controller: _dropDownFieldController,
                        items: _getIngNames(),
                        hintText: "Enter Ingredient Name",
                        hintStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                        onValueChanged: (value) async {
                          _setState(() {
                            _currentChosenIng = value;
                          });
                          var tempList = await masterBloc.getIngs(
                              query: _currentChosenIng);
                          if (tempList.isNotEmpty) {
                            _setState(() {
                              ingToAddTo = tempList[0];
                            });
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ingAmountTextController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(hintText: "Enter amount"),
                              onChanged: (value) {
                                try {
                                  num = double.parse(value);
                                } catch (e) {
                                  num = -1;
                                  print(e);
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
                              items: <String>[
                                'Number',
                                'mg',
                                'ml'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  RaisedButton(
                    color: kPrimaryColor,
                    child: Text("Cancel"),
                    onPressed: () {
                      _dropDownFieldController?.clear();
                      _ingAmountTextController?.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: kPrimaryColor,
                    child: Text("Add to house"),
                    onPressed: () {
                      Ingredient newIng = ingToAddTo;
                      switch (dropdownValue) {
                        case "Number":
                          newIng.nQuantity += num;
                          masterBloc.updateIng(newIng, true);
                          break;
                        case "mg":
                          newIng.kgQuantity += num;
                          masterBloc.updateIng(newIng, true);
                          break;
                        case "ml":
                          newIng.lrQuantity += num;
                          masterBloc.updateIng(newIng, true);
                          break;
                        default:
                          break;
                      }
                      _dropDownFieldController?.clear();
                      _ingAmountTextController?.clear();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        });
  }

  List<String> _getIngNames() {
    List<String> names = [];
    for (var ing in listOfAllIngs) {
      names.add(ing.name);
    }
    return names;
  }
}
