import 'dart:async';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/model/ingredient.dart';

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
              child: ListView.builder(
                itemCount: ingList.length,
                itemBuilder: (context, itemIndex) {
                  return GestureDetector(
                    onTap: () {
                      _ingClickAlertDialog(ingList[itemIndex]);
                    },
                    child: RecipeIngredientsCard(
                      name: ingList[itemIndex].name,
                      amount: ingList[itemIndex].kgQuantity > 0
                          ? ingList[itemIndex].kgQuantity.toString()
                          : ingList[itemIndex].lrQuantity > 0
                              ? ingList[itemIndex].lrQuantity.toString()
                              : ingList[itemIndex].nQuantity.toString(),
                      image: ingList[itemIndex].image,
                      unit: ingList[itemIndex].unit,
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  void _ingClickAlertDialog(Ingredient ingredient) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Ingredient"),
          );
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
                      ingredientBloc.updateIng(newIng);
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
