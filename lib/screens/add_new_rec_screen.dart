import 'dart:io';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
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
  List<Ingredient> ingsListOfNewRecipe = [];
  List<step.Step> recipeStepList = [];
  var _imagePicker = ImagePicker();
  TextEditingController _ingSearchController;
  String _currentChosenIng = "";
  ScrollController _ingListController;
  Widget chosenImage;
  bool addPhotoPressed = false;
  TextEditingController _stepController;
  String imageFilePath = "";
  TextEditingController _recipeTitleController;

  void getImageFromDevice() {
    PickedFile pickedFile;
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
                children: [Icon(Icons.camera_alt), Text("Capture new photo")],
              ),
              onPressed: () async {
                isGalleryOrCamera = 1;
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    ).then((value) async {
      if (isGalleryOrCamera == 0) {
        pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
      } else if (isGalleryOrCamera == 1) {
        pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
      } else {
        //nothing picked
      }
      if (pickedFile != null) {
        setState(() {
          chosenImage = Image.file(
            File(pickedFile.path),
            fit: BoxFit.fitWidth,
          );
          imageFilePath = pickedFile.path;
        });
      } else {
        setState(() {
          chosenImage = InitChosenImage();
        });
      }
    });
  }

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    _ingListController = ScrollController();
    _recipeTitleController = TextEditingController();
    chosenImage = InitChosenImage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter recipe title"),
                content: TextField(
                  controller: _recipeTitleController,
                  onChanged: (value) {
                    setState(() {
                      recipeTitle = value;
                    });
                  },
                ),
                actions: [
                  RaisedButton(
                    color: kPrimaryColor,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: kPrimaryColor,
                    child: Text("Save"),
                    onPressed: () {
                      // TODO save recipe in db
                      // step.RecipeInstructions recipeInstructions;
                      // recipeInstructions.steps = recipeStepList;
                      List<step.RecipeInstructions> list = [];
                      list.add(step.RecipeInstructions(
                          name: "", steps: recipeStepList));
                      masterBloc.addRec(
                        Recipe(
                            title: recipeTitle,
                            ingredientsList: ingsListOfNewRecipe,
                            analyzedInstructions: list,
                            isFavorite: true,
                            image: imageFilePath,
                            cheap: false,
                            healthScore: 0,
                            dishTypes: [""],
                            readyInMinutes: 5,
                            servings: 1,
                            sourceName: "",
                            spoonacularSourceUrl: "",
                            summary: ""),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
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
                expandedHeight: height * 1.82 / 5,
                collapsedHeight: height / 4,
                floating: false,
                pinned: true,
                snap: false,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: GestureDetector(
                        child: Container(
                          child: chosenImage,
                          width: double.infinity, //stones
                        ),
                        onTap: () {
                          getImageFromDevice();
                        },
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
                      indicatorColor: kPrimaryColor,
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
      controller: _ingListController,
      itemBuilder: (context, index) {
        if (index != _insertedIngsCount)
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: UniqueKey(),
            child: RecipeIngredientsCard(
              name: ingsListOfNewRecipe[index].name,
              image: ingsListOfNewRecipe[index].image,
            ),
            onDismissed: (direction) {
              setState(() {
                ingsListOfNewRecipe.removeAt(index);
                _insertedIngsCount--;
              });
            },
          );
        return InsertNewButton(
          type: "Ingredient",
          onPress: () async {
            masterBloc.getIngs().then((ingsListGlobal) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Search for Ingredient"),
                    content: DropDownField(
                      strict: false,
                      controller: _ingSearchController,
                      items: _getIngNames(ingsListGlobal),
                      hintText: "Enter Ingredient Name",
                      hintStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                      onValueChanged: (value) async {
                        setState(() {
                          _currentChosenIng = value;
                        });
                        var tempList =
                            await masterBloc.getIngs(query: _currentChosenIng);
                        if (tempList.isNotEmpty &&
                            !ingsListOfNewRecipe.contains(tempList[0])) {
                          setState(() {
                            ingsListOfNewRecipe.add(tempList[0]);
                            _insertedIngsCount++;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            });
            setState(() {
              _insertedIngsCount = ingsListOfNewRecipe.length;
            });
          },
        );
      },
      itemCount: _insertedIngsCount + 1,
    );
  }

  List<String> _getIngNames(List<Ingredient> list) {
    List<String> names = [];
    for (var ing in list) {
      names.add(ing.name);
    }
    return names;
  }

  Widget _prepareStepTabContents() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index != _insertedStepsCount) {
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: UniqueKey(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${recipeStepList[index].number}_ ${recipeStepList[index].step}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Divider()
              ],
            ),
            onDismissed: (direction) {
              setState(() {
                recipeStepList.removeAt(index);
                _insertedStepsCount--;
              });
            },
          );
        } else {
          String stepContents;
          return InsertNewButton(
            type: "Step",
            onPress: () {
              showDialog(
                context: (context),
                builder: (context) {
                  return AlertDialog(
                    title: Text("Type step details..."),
                    content: TextField(
                      controller: _stepController,
                      decoration:
                          InputDecoration(hintText: "Type step in here"),
                      onChanged: (value) {
                        stepContents = value;
                      },
                    ),
                    actions: [
                      RaisedButton(
                        color: kPrimaryColor,
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      RaisedButton(
                        color: kPrimaryColor,
                        child: Text("Add step"),
                        onPressed: () {
                          setState(() {
                            List<step.Ent> ent = [];
                            ent.add(step.Ent(name: "", image: "", id: 0));
                            step.Step newStep = step.Step(
                                number: recipeStepList.length + 1,
                                step: stepContents,
                                equipment: ent,
                                ingredients: ent);
                            recipeStepList.add(newStep);
                            _insertedStepsCount++;
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ],
                  );
                },
              );
              setState(() {
                _insertedStepsCount = recipeStepList.length;
              });
            },
          );
        }
      },
      itemCount: _insertedStepsCount + 1,
    );
  }
}

class InitChosenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class InsertNewButton extends StatelessWidget {
  InsertNewButton({this.type, this.onPress});
  final String type;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        color: kPrimaryColor,
        child: Text(
          "Insert New $type",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPress,
      ),
    );
  }
}
