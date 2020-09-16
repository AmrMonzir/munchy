import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/model/ingredient.dart';

// DismissDirection _dismissDirection = DismissDirection.horizontal;

class IngredientsWidget extends StatefulWidget {
  IngredientsWidget(
      {@required this.ingredientBloc, @required this.gridButtonSelected});
  final IngredientBloc ingredientBloc;
  final bool gridButtonSelected;
  // final AsyncSnapshot<Ingredient> snapshot;

  @override
  _IngredientsWidgetState createState() => _IngredientsWidgetState();
}

class _IngredientsWidgetState extends State<IngredientsWidget> {
  List<Ingredient> listOfIngs = [];
  StreamSubscription<IngredientEvent> streamSubscription;

  void ingredientNotificationReceived(IngredientEvent event) {
    if (event.eventType == IngEventType.add) {
      setState(() {
        listOfIngs.add(event.ingredient);
      });
    } else if (event.eventType == IngEventType.delete) {
      setState(() {
        listOfIngs.remove(event.ingredient);
      });
    } else if (event.eventType == IngEventType.update) {
      //TODO: do something about update event
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => prepareList());
    streamSubscription = widget.ingredientBloc
        .registerToStreamController(ingredientNotificationReceived);
  }

  void prepareList() {
    widget.ingredientBloc.getIngs().then((value) {
      setState(() {
        listOfIngs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (!widget.gridButtonSelected) {
      return ListView.builder(
        itemCount: listOfIngs.length,
        itemBuilder: (context, itemPosition) {
          return ListTile(
            title: Text(listOfIngs[itemPosition].name +
                " | Is essential: ${listOfIngs[itemPosition].isEssential}"),
            leading: Image(image: AssetImage("images/placeholder_food.png")),
            onTap: () {
              // widget.ingredientBloc.deleteIng(listOfIngs[itemPosition]);
            },
          );
        },
      );
    } else {
      return GridView.builder(
        itemCount: listOfIngs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5),
        itemBuilder: (context, index) {
          return Card(
            child: new GridTile(
              footer: GridTileBar(
                title: Card(
                  child: Text(listOfIngs[index].name),
                  color: Colors.black,
                ),
              ),
              child: Image(
                image: AssetImage("images/placeholder_food.png"),
              ),
            ),
          );
        },
      );
    }
  }
}
