import 'dart:async';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../constants.dart';

class LocalIngsScreen extends StatefulWidget {
  @override
  _LocalIngsScreenState createState() => _LocalIngsScreenState();
}

class _LocalIngsScreenState extends State<LocalIngsScreen> {
  List<Ingredient> ingList = [];
  List<Ingredient> listOfAllIngs = [];
  MasterBloc ingredientBloc;
  TextEditingController searchController;
  StreamSubscription<IngredientEvent> streamSubscription;
  TextEditingController _dropDownFieldController;
  TextEditingController _ingAmountTextController;
  String dropdownValue = "mg";
  String hintTextUnit = "";
  String hintTextAmount = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  FirebaseHelper firebaseHelper;

  void _ingUpdateNotificationReceived(IngredientEvent event) {
    if (event.eventType == IngEventType.update) prepareList();
  }

  @override
  void initState() {
    super.initState();
    ingredientBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => prepareList());
    streamSubscription = ingredientBloc
        .registerToIngStreamController(_ingUpdateNotificationReceived);
    firebaseHelper = FirebaseHelper();
    _dropDownFieldController = TextEditingController();
    _ingAmountTextController = TextEditingController();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  void prepareList() {
    ingredientBloc.getLocalIngs().then((value) {
      setState(() {
        ingList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Hero(
                child: Image.asset(
                  'images/appBarLogo.png',
                  height: 60,
                  width: 30,
                  color: Colors.white,
                ),
                tag: "logo",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Local Ingredients"),
          ],
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: kAccentColor,
          foregroundColor: Colors.white,
          onPressed: () async {
            listOfAllIngs = await ingredientBloc.getIngs();
            _floatingActionButtonAlertDialog();
          }),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextField(
                controller: searchController,
                decoration:
                    InputDecoration(hintText: "Search for ingredients..."),
                onChanged: (value) {
                  setState(() {
                    ingList
                        .retainWhere((element) => element.name.contains(value));
                  });
                  if (value == "") prepareList();
                },
              ),
            ),
          ),
          Expanded(
              flex: 10,
              child: SmartRefresher(
                controller: _refreshController,
                header: WaterDropHeader(),
                onRefresh: () async {
                  await firebaseHelper.syncOnlineIngsToLocal(context);
                  _refreshController.refreshCompleted();
                },
                enablePullDown: true,
                child: ListView.builder(
                  itemCount: ingList.length,
                  itemBuilder: (context, itemIndex) {
                    //TODO check why it doesn't delete from firebase on dismissing
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                      ),
                      key: UniqueKey(),
                      child: InkWell(
                        onLongPress: () {
                          _ingClickAlertDialog(ingList[itemIndex]);
                        },
                        child: RecipeIngredientsCard(
                          name: ingList[itemIndex].name,
                          amountKG: ingList[itemIndex].kgQuantity.toString(),
                          amountLR: ingList[itemIndex].lrQuantity.toString(),
                          amountN:
                              ingList[itemIndex].nQuantity.floor().toString(),
                          image: ingList[itemIndex].image,
                          unit: ingList[itemIndex].unit,
                        ),
                      ),
                      onDismissed: (direction) {
                        Ingredient ingToDeleteAmounts = ingList[itemIndex];
                        ingToDeleteAmounts.kgQuantity = 0;
                        ingToDeleteAmounts.lrQuantity = 0;
                        ingToDeleteAmounts.nQuantity = 0;
                        ingredientBloc.updateIng(ingToDeleteAmounts, true);
                        setState(() {
                          ingList.removeAt(itemIndex);
                        });
                      },
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  void _ingClickAlertDialog(Ingredient ingredient) {
    double num;
    String hintTextAmount;
    if (ingredient.kgQuantity > 0) {
      hintTextAmount = ingredient.kgQuantity.toString();
      hintTextUnit = "mg";
    } else if (ingredient.lrQuantity > 0) {
      hintTextAmount = ingredient.kgQuantity.toString();
      hintTextUnit = "ml";
    } else {
      hintTextAmount = ingredient.nQuantity.toString();
      hintTextUnit = "${ingredient.name}";
    }
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _setState) {
            return AlertDialog(
              title: Text("Edit Ingredient ${ingredient.name}"),
              content: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ingAmountTextController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "$hintTextAmount $hintTextUnit",
                        ),
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
                            if (newValue != "Number")
                              hintTextUnit = newValue;
                            else
                              hintTextUnit = ingredient.name + "s";
                            if (newValue == "mg")
                              hintTextAmount = ingredient.kgQuantity.toString();
                            if (newValue == "ml")
                              hintTextAmount = ingredient.lrQuantity.toString();
                            if (newValue == "Number")
                              hintTextAmount =
                                  ingredient.nQuantity.floor().toString();
                          });
                        },
                        items: <String>['Number', 'mg', 'ml']
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
              ),
              actions: [
                RaisedButton(
                  color: kPrimaryColor,
                  child: Text("Cancel"),
                  onPressed: () {
                    _ingAmountTextController?.clear();
                    _dropDownFieldController?.clear();
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: kPrimaryColor,
                  child: Text("Edit ingredient amounts"),
                  onPressed: () {
                    Ingredient newIng = ingredient;
                    switch (dropdownValue) {
                      case "Number":
                        newIng.nQuantity = num;
                        break;
                      case "mg":
                        newIng.kgQuantity = num;
                        break;
                      case "ml":
                        newIng.lrQuantity = num;
                        break;
                      default:
                        break;
                    }
                    ingredientBloc.updateIng(newIng, true);
                    _dropDownFieldController?.clear();
                    _ingAmountTextController?.clear();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  void _floatingActionButtonAlertDialog() {
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
                    SingleChildScrollView(
                      child: DropDownField(
                        itemsVisibleInDropdown: 2,
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
                          var tempList = await ingredientBloc.getIngs(
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
                      _ingAmountTextController?.clear();
                      _dropDownFieldController?.clear();
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
                          break;
                        case "mg":
                          newIng.kgQuantity += num;
                          break;
                        case "ml":
                          newIng.lrQuantity += num;
                          break;
                        default:
                          break;
                      }
                      ingredientBloc.updateIng(newIng, true);
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
