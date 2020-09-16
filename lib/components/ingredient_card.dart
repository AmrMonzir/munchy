import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/model/ingredient.dart';

class IngredientCard extends StatefulWidget {
  final onPress;
  final ingObject;

  IngredientCard({this.onPress, this.ingObject});

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  IngredientBloc ingredientBloc;
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
    // TODO: implement initState
    super.initState();
    ingredientBloc = BlocProvider.of<IngredientBloc>(context);
    checkboxValue = widget.ingObject.isEssential;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _showPopupMenu(details.globalPosition, widget.ingObject);
      },
      child: Column(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                title: Text(widget.ingObject.name),
                value: checkboxValue,
                onChanged: (value) {
                  setState() {
                    ingredientBloc.updateIng(widget.ingObject);
                    ingredientBloc.getIng(widget.ingObject.id);
                  }
                },
              );
            },
          ),
          Divider(
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}
