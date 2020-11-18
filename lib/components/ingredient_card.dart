import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/model/ingredient.dart';

class IngredientCard extends StatefulWidget {
  final onPressDelete;
  final onPressEdit;
  final Ingredient ingObject;

  IngredientCard({this.onPressDelete, this.ingObject, this.onPressEdit});

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
            onPressed: widget.onPressDelete,
          ),
        ),
        PopupMenuItem(
          value: "Edit",
          child: FlatButton(
            child: Text("Edit"),
            onPressed: widget.onPressEdit,
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

  //TODO fix this, it could potentially not work
  Widget getImageURL() {
    try {
      return Image(
        image: NetworkImage(widget.ingObject.image?.toString()?.trim()),
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
              onChanged: (value) {
                setState(() {
                  checkboxValue = value;
                });
                Ingredient newIng = widget.ingObject;
                newIng.isEssential = value;
                ingredientBloc.updateIng(newIng);
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
