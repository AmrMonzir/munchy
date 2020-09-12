import 'package:flutter/material.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/database.dart';
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

  IngredientBloc ingredientBloc = IngredientBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _scrollController = ScrollController();
    ingredientBloc.addIng(Ingredient(id: 0, name: "asd"));
    // setState(() {
    //   ingList = ingredientBloc.getIngs();
    // });
  }

  @override
  void dispose() {
    ingredientBloc.dispose();
    super.dispose();
  }

  List<Text> IngTextWidgets() {
    List<Text> list = [];
    for (var ing in ingList) {
      setState(() {
        list.add(Text(ing.name));
        print(list.toString());
      });
    }
    return list;
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
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("${snapshot.data}");
          }
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: Text("No data yet"));
        },
      ),
    );
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
