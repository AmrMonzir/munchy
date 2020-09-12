import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/database.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/model/ingredient.dart';

class RecipesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Text> textList = [];
  List<Ingredient> ingList = [];
  var ingName;
  var ingId;
  bool _isEssential = true;
  ScrollController _scrollController;
  TextEditingController _controller1;
  TextEditingController _controller2;

  final IngredientBloc ingredientBloc = IngredientBloc();
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    ingredientBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            _getAlertDialogue();
          }),
      body: StreamBuilder(
        stream: ingredientBloc.ings,
        builder:
            (BuildContext context, AsyncSnapshot<List<Ingredient>> snapshot) {
          return getIngsWidget(snapshot);
          // if (snapshot.hasData) {
          //   return Center(child: Text("${snapshot.data.toString()}"));
          // } else {
          //   return Center(
          //     child: Text("No data yet"),
          //   );
          // }
        },
      ),
    );
  }

  Widget getIngsWidget(AsyncSnapshot<List<Ingredient>> snapshot) {
    if (snapshot.hasData) {
      // return Text("${snapshot.data.toString()}");
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Ingredient ing = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Ingredient item by ID whenever
                    the card is dismissed
                    */
                    ingredientBloc.deleteIngById(ing.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(ing),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200], width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: Text(
                        ing.name,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
                child: Text("No Ings"),
              ),
            );
    }
    if (snapshot.hasError) {
      return Text("${snapshot.error}");
    }
    return Center(child: Text("No data yet"));
  }

  void _getAlertDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add ingredient"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TextField(
                      controller: _controller1,
                      decoration: InputDecoration(hintText: "Ingredient name"),
                      onChanged: (value) {
                        ingName = value;
                      },
                    ),
                    TextField(
                      controller: _controller2,
                      decoration: InputDecoration(hintText: "Ingredient id"),
                      onChanged: (value) {
                        ingId = int.parse(value.trim());
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
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              RaisedButton(
                child: Text("OK"),
                onPressed: () {
                  ingredientBloc.addIng(Ingredient(
                      name: ingName, id: ingId, isEssential: _isEssential));
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
    // ingredientBloc.eventSink.add(IngEventType.add);
  }
}
