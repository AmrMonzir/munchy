import 'dart:async';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/model/ingredient.dart';

import '../constants.dart';

// DismissDirection _dismissDirection = DismissDirection.horizontal;

class IngredientsWidget extends StatefulWidget {
  IngredientsWidget(
      {@required this.ingredientBloc,
      this.gridButtonSelected,
      this.listOfIngs});
  final List<Ingredient> listOfIngs;
  final MasterBloc ingredientBloc;
  final bool gridButtonSelected;

  @override
  _IngredientsWidgetState createState() => _IngredientsWidgetState();
}

class _IngredientsWidgetState extends State<IngredientsWidget> {
  StreamSubscription<IngredientEvent> streamSubscription;
  bool _isEssentialThresholdEnabled = false;
  TextEditingController _essentialThresholdController;
  String essentialThresholdForIng = "";
  bool checkboxValue;

  void ingredientNotificationReceived(IngredientEvent event) {
    if (event.eventType == IngEventType.add) {
      setState(() {
        widget.listOfIngs.add(event.ingredient);
      });
    } else if (event.eventType == IngEventType.delete) {
      setState(() {
        widget.listOfIngs.remove(event.ingredient);
      });
    } else if (event.eventType == IngEventType.update) {
      for (int i = 0; i < widget.listOfIngs.length; i++) {
        var ing = widget.listOfIngs[i];
        if (ing.name == event.ingredient.name) {
          //found the ingredient that matches the one that fired the event
          if (ing.isEssential != event.ingredient.isEssential) {
            List<Ingredient> l = [];
            l.add(Ingredient(
                name: ing.name, isEssential: event.ingredient.isEssential));
            setState(() {
              widget.listOfIngs.replaceRange(i, i, l);
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.ingredientBloc
        .registerToIngStreamController(ingredientNotificationReceived);
    _essentialThresholdController = TextEditingController();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    if (widget.gridButtonSelected) {
      return ListView.builder(
        itemCount: widget.listOfIngs.length,
        itemBuilder: (context, itemPosition) {
          return IngredientCard(
            ingObject: widget.listOfIngs[itemPosition],
            onPressDelete: () {
              widget.ingredientBloc.deleteIng(widget.listOfIngs[itemPosition]);
            },
            onPressEdit: () {
              _showEditIngDialog(widget.listOfIngs[itemPosition]);
            },
          );
        },
      );
    } else {
      return GridView.builder(
        itemCount: widget.listOfIngs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 4 : 8),
        itemBuilder: (context, index) {
          return Card(
            child: new GridTile(
              footer: GridTileBar(
                title: Container(
                  child: BorderedText(
                    strokeColor: Colors.black,
                    strokeWidth: 3,
                    child: Text(
                      widget.listOfIngs[index].name,
                    ),
                  ),
                ),
              ),
              child: getImage(index),
            ),
          );
        },
      );
    }
  }

  Widget getImage(int index) {
    try {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image:
              NetworkImage(widget.listOfIngs[index].image?.toString()?.trim()),
        ),
      );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: AssetImage("images/placeholder_food.png"),
        ),
      );
    }
  }

  void _showEditIngDialog(Ingredient ing) {
    checkboxValue = ing.isEssential;
    String dropdownValue = ing.essentialUnit == null ? "mg" : ing.essentialUnit;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit ${ing.name} entry"),
            content: StatefulBuilder(
              builder: (context, _setState) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter essential threshold"),
                        keyboardType: TextInputType.number,
                        controller: _essentialThresholdController,
                        enabled: _isEssentialThresholdEnabled,
                        onChanged: (threshValue) {
                          _setState(() {
                            essentialThresholdForIng = threshValue;
                          });
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
                        items: <String>['Number', 'mg', 'ml']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        _setState(() {
                          checkboxValue = value;
                          _isEssentialThresholdEnabled = value;
                        });
                      },
                    )
                  ],
                );
              },
            ),
            actions: [
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  _essentialThresholdController?.clear();
                  Navigator.pop(context);
                },
                color: kPrimaryColor,
              ),
              RaisedButton(
                child: Text("OK"),
                onPressed: () {
                  _essentialThresholdController?.clear();
                  double num;
                  try {
                    num = double.parse(essentialThresholdForIng);
                  } catch (e) {
                    num = -1;
                  }
                  Ingredient newIng = ing;
                  newIng.isEssential = checkboxValue;
                  newIng.essentialThreshold = num;
                  newIng.essentialUnit = dropdownValue;
                  widget.ingredientBloc.updateIng(newIng, true);
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              )
            ],
          );
        });
  }
}
