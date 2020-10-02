import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';
import '../constants.dart';
import 'package:munchy/model/recipe_instructions.dart' as step;

class AddNewRecipeScreen extends StatefulWidget {
  @override
  _AddNewRecipeScreenState createState() => _AddNewRecipeScreenState();
}

class _AddNewRecipeScreenState extends State<AddNewRecipeScreen> {
  int _insertedIngsCount = 0;
  int _insertedStepsCount = 0;
  MasterBloc masterBloc;
  String recipeTitle = "";
  List<Ingredient> ingsList = [];
  List<step.Step> recipeStepList = [];
  var _imagePicker = ImagePicker();

  Widget getImageFromDevice() {
    return GestureDetector(
      onTap: () async {
        //TODO get image dialog
        int isGalleryOrCamera = -1;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Add photo"),
              actions: [
                RaisedButton(
                  color: kPrimaryColor,
                  child: Row(
                    children: [Icon(Icons.image), Text("Pick from gallery")],
                  ),
                  onPressed: () {
                    isGalleryOrCamera = 0;
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: kPrimaryColor,
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      Text("Capture new photo")
                    ],
                  ),
                  onPressed: () {
                    isGalleryOrCamera = 1;
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        PickedFile pickedFile;

        if (isGalleryOrCamera == 0) {
          pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
        } else if (isGalleryOrCamera == 1) {
          pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
        } else {
          //nothing picked
        }
        setState(() {
          if (pickedFile != null) {
            return Image.file(File(pickedFile.path));
          } else {
            return Image.asset("images/placeholder_food.png");
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Icon(
            Icons.add,
            size: 100,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Add Photo",
            style: TextStyle(fontSize: 35),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    masterBloc.disposeRecController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          // TODO save recipe in db
          step.RecipeInstructions recipeInstructions;
          recipeInstructions.steps = recipeStepList;
          List<step.RecipeInstructions> list = [];
          list.add(recipeInstructions);
          masterBloc.addRec(
            Recipe(
                title: recipeTitle,
                ingredientsList: ingsList,
                analyzedInstructions: list,
                isFavorite: true),
          );
          Navigator.pop(context);
        },
      ),
      backgroundColor: kScaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: kScaffoldBackgroundColor,
                expandedHeight: height * 2 / 3,
                collapsedHeight: height / 4,
                floating: false,
                pinned: true,
                snap: false,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: getImageFromDevice(),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: new EdgeInsets.all(16.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Icon(Icons.menu), text: "Ingredients"),
                        Tab(
                            icon: Icon(Icons.restaurant_menu),
                            text: "Preparation Steps"),
                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _prepareIngTabContents(),
              _prepareStepTabContents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prepareIngTabContents() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index != _insertedIngsCount) {
          return RecipeIngredientsCard(
            name: ingsList[index].name,
            image: kBaseIngredientURL + ingsList[index].image,
          );
        } else {
          return InsertNewButton(
            type: "Ingredient",
            onPress: () {
              //TODO insert new ingredient code
            },
          );
        }
      },
      itemCount: _insertedIngsCount + 1,
    );
  }

  Widget _prepareStepTabContents() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index != _insertedStepsCount) {
          String allSteps = "";
          for (var step in recipeStepList) {
            if (step.step != null)
              allSteps += "${step.number}_ ${step.step}  \n\n";
          }
          return Text(
            allSteps,
            style: TextStyle(fontSize: 18),
          );
        } else
          return InsertNewButton(
            type: "Step",
            onPress: () {
              //TODO insert new step code
            },
          );
      },
      itemCount: _insertedStepsCount + 1,
    );
  }
}

class InsertNewButton extends StatelessWidget {
  InsertNewButton({this.type, this.onPress});
  final String type;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Insert New $type"),
      onPressed: onPress,
    );
  }
}
