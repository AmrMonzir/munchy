import 'dart:async';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/model/ingredient.dart';

// DismissDirection _dismissDirection = DismissDirection.horizontal;

class IngredientsWidget extends StatefulWidget {
  IngredientsWidget({@required this.ingredientBloc, this.gridButtonSelected});
  final IngredientBloc ingredientBloc;
  final bool gridButtonSelected;

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
      for (int i = 0; i < listOfIngs.length; i++) {
        var ing = listOfIngs[i];
        if (ing.name == event.ingredient.name) {
          //found the ingredient that matches the one that fired the event
          if (ing.isEssential != event.ingredient.isEssential) {
            List<Ingredient> l = [];
            l.add(Ingredient(
                name: ing.name, isEssential: event.ingredient.isEssential));
            setState(() {
              listOfIngs.replaceRange(i, i, l);
            });
          }
        }
      }
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
    var orientation = MediaQuery.of(context).orientation;
    if (widget.gridButtonSelected) {
      return ListView.builder(
        itemCount: listOfIngs.length,
        itemBuilder: (context, itemPosition) {
          return IngredientCard(
            ingObject: listOfIngs[itemPosition],
            onPress: () {
              widget.ingredientBloc.deleteIng(listOfIngs[itemPosition]);
            },
          );
        },
      );
    } else {
      return GridView.builder(
        itemCount: listOfIngs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 5 : 8),
        itemBuilder: (context, index) {
          return Card(
            child: new GridTile(
              footer: GridTileBar(
                title: Container(
                  child: BorderedText(
                    strokeColor: Colors.black,
                    strokeWidth: 3,
                    child: Text(
                      listOfIngs[index].name,
                    ),
                  ),
                ),
              ),
              child: Image(
                image: NetworkImage(listOfIngs[index].image.toString().trim()),
              ),
            ),
          );
        },
      );
    }
  }
}

/*return GridView.builder(
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
      );*/
