import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/model/ingredient.dart';

// DismissDirection _dismissDirection = DismissDirection.horizontal;

class IngredientsWidget extends StatefulWidget {
  IngredientsWidget({@required this.ingredientBloc});
  final IngredientBloc ingredientBloc;
  // final bool gridButtonSelected;

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
  //
  // _showPopupMenu(Offset offset, Ingredient ingredient) async {
  //   double left = offset.dx;
  //   double top = offset.dy;
  //   await showMenu(
  //     elevation: 8.0,
  //     context: context,
  //     position: RelativeRect.fromLTRB(left, top, 1000000, 0),
  //     items: [
  //       PopupMenuItem(
  //         child: FlatButton(
  //           child: Text("Delete"),
  //           onPressed: () {
  //             widget.ingredientBloc.deleteIng(ingredient);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
