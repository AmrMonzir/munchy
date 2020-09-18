import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/components/ings_widget.dart';
import 'package:munchy/model/ingredient.dart';

import '../constants.dart';

class GlobalIngredientsScreen extends StatefulWidget {
  @override
  _GlobalIngredientsScreenState createState() =>
      _GlobalIngredientsScreenState();
}

class _GlobalIngredientsScreenState extends State<GlobalIngredientsScreen> {
  List<Text> textList = [];
  List<Ingredient> ingList = [];
  var ingName;
  var ingId;
  bool _isEssential = true;
  ScrollController _scrollController;
  TextEditingController _controller1;
  IngredientBloc ingredientBloc;
  IconData grid = Icons.list;
  // bool gridButtonSelected = true;

  @override
  void initState() {
    super.initState();
    ingredientBloc = BlocProvider.of<IngredientBloc>(context);
    _controller1 = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    ingredientBloc.dispose();
    super.dispose();
  }

  //
  // _gridIconToggle() {
  //   grid = (grid == Icons.list) ? Icons.grid_on : Icons.list;
  //   gridButtonSelected = !gridButtonSelected;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                child: Hero(
                  child: Image.asset(
                    'images/logo.png',
                    height: 60,
                    width: 30,
                  ),
                  tag: "logo",
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Global Ingredients"),
            ],
          ),
          elevation: 0,
          // Commented to remove the grid toggle button
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          //     child: Container(
          //       width: 36,
          //       height: 30,
          //       decoration:
          //           BoxDecoration(borderRadius: BorderRadius.circular(10)),
          //       child: IconButton(
          //         icon: Icon(
          //           grid,
          //           color: Colors.white,
          //         ),
          //         onPressed: () {
          //           setState(() {
          //             _gridIconToggle();
          //           });
          //         },
          //       ),
          //     ),
          //   ),
          // ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            onPressed: () {
              _showAlertDialogue();
            }),
        body: IngredientsWidget(
          ingredientBloc: ingredientBloc,
        ));
  }

  void _showAlertDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add ingredient"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller1,
                    decoration: InputDecoration(hintText: "Ingredient name"),
                    onChanged: (value) {
                      ingName = value;
                    },
                  ),
                  SwitchListTile(
                    value: _isEssential,
                    onChanged: (value) {
                      setState(() {
                        _isEssential = value;
                      });
                    },
                    activeColor: kPrimaryColor,
                    title: Text("Is essential?"),
                  ),
                ],
              );
            },
          ),
          actions: [
            RaisedButton(
              color: kPrimaryColor,
              child: Text("Cancel"),
              onPressed: () {
                _controller1.clear();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              color: kPrimaryColor,
              child: Text("OK"),
              onPressed: () {
                _controller1.clear();
                ingredientBloc
                    .addIngGlobal(Ingredient(
                        name: ingName, id: ingId, isEssential: _isEssential))
                    .then((value) {
                  if (!value) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Error"),
                        content: Text("Ingredient already added!"),
                        actions: [
                          RaisedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // to display toast
                    // TODO fix toast message
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text("Added Ingredient"),
                    // ));
                  }
                });

                // Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
