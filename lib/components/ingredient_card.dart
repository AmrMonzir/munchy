import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/ingredient.dart';

class IngredientCard extends StatefulWidget {
  final onPress;
  final ingObject;

  IngredientCard({this.onPress, this.ingObject});

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  MasterBloc ingredientBloc;
  bool checkboxValue;

  _showPopupMenu(Offset offset, Ingredient ingredient) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      elevation: 8.0,
      context: context,
      position: RelativeRect.fromLTRB(left, top, 1000000, 0),
      items: [
        PopupMenuItem(
          value: "Delete",
          child: FlatButton(
            child: Text("Delete"),
            onPressed: widget.onPress,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    ingredientBloc = BlocProvider.of<MasterBloc>(context);
    checkboxValue = widget.ingObject.isEssential;
  }

  Widget getImageURL() {
    try {
      return Image(
        image: NetworkImage(widget.ingObject.image.toString().trim()),
        height: 60,
        width: 60,
      );
    } catch (e) {
      return Image(
        image: AssetImage("images/placeholder_food.png"),
        height: 60,
        width: 60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (details) {
                  _showPopupMenu(details.globalPosition, widget.ingObject);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: getImageURL(),
                    ),
                    Padding(
                      child: widget.ingObject.name.toString().length >= 25
                          ? Text(
                              widget.ingObject.name,
                              style: TextStyle(fontSize: 13),
                            )
                          : Text(
                              widget.ingObject.name,
                              style: TextStyle(fontSize: 16),
                            ),
                      padding: EdgeInsets.only(left: 8),
                    ),
                  ],
                ),
              ),
            ),
            Text("Essential"),
            Checkbox(
              value: checkboxValue,
              //TODO fix the onChanged to update the ing entry in db not only in ui
              onChanged: (value) {
                setState(() {
                  checkboxValue = value;
                });
                ingredientBloc.updateIng(widget.ingObject);
                ingredientBloc.getIng(widget.ingObject.id);
              },
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }
}

/*CheckboxListTile(
                title: Text(widget.ingObject.name),
                value: checkboxValue,
                onChanged: (value) {
                  ingredientBloc.updateIng(widget.ingObject);
                  ingredientBloc.getIng(widget.ingObject.id);
                },
              );*/

/*GestureDetector(
      onTapDown: (details) {
        _showPopupMenu(details.globalPosition, widget.ingObject);
      },
      child: */
