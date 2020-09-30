import 'dart:async';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/model/ing_repo.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/rec_repo.dart';
import 'package:munchy/model/recipe.dart';

enum IngEventType { add, delete, update }
enum RecEventType { add, delete }

class MasterBloc implements BlocBase {
  //Get instance of the Repository
  final _ingRepository = IngredientRepository();
  final _recRepository = RecipeRepository();

  final _ingredientController = StreamController<IngredientEvent>.broadcast();
  final _recipeController = StreamController<RecipeEvent>.broadcast();

  //================== INGREDIENT BLOC LOGIC =============================//

  StreamSubscription<IngredientEvent> registerToIngStreamController(event) {
    return _ingredientController.stream.listen(event);
  }

  Future<List<Ingredient>> getIngs({String query}) async {
    //sink is a way of adding data reactive-ly to the stream
    //by registering a new event
    return await _ingRepository.getAllIngs(query: query);
  }

  Future<Ingredient> getIng(int id) async {
    return await _ingRepository.getIng(id);
  }

  Future<bool> addIngGlobal(Ingredient ingredient) async {
    List<Ingredient> result = await getIngs();
    bool isFound = false;
    for (var element in result) {
      isFound = (element.name == ingredient.name) ? true : false;
    }
    print("is found value = $isFound");
    if (!isFound) {
      await _ingRepository.insertIng(ingredient);
      _ingredientController.sink.add(
          IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
      return true;
    }
    return false;
  }

  void addIngLocal(Ingredient ingredient) async {
    List<Ingredient> result = await getIngs();
    bool isFound = false;
    for (var element in result) {
      isFound = (element.name == ingredient.name) &&
              element.isAvailable == ingredient.isAvailable
          ? true
          : false;
    }

    // if isFound is true found an available ing with the same name, update it with the ing.quantity (increment)
    // if isFound is false, couldn't find an available ing with the same name
    // so create a new available ing with that given quantity

    if (!isFound) {
      await _ingRepository.insertIng(ingredient);
      _ingredientController.sink.add(
          IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
    } else {
      await _ingRepository.updateIng(ingredient);
      _ingredientController.sink.add(IngredientEvent(
          ingredient: ingredient, eventType: IngEventType.update));
    }
  }

  updateIng(Ingredient ingredient) async {
    await _ingRepository.updateIng(ingredient);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.update));
  }

  deleteIng(Ingredient ingredient) async {
    await _ingRepository.deleteIngById(ingredient.id);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.delete));
  }

  disposeIngController() {
    _ingredientController.close();
  }

  //================== RECIPE BLOC LOGIC =============================//
  StreamSubscription<RecipeEvent> registerToRecStreamController(event) {
    return _recipeController.stream.listen(event);
  }

  Future<dynamic> addRec(Recipe recipe) async {
    return await _recRepository.insertRec(recipe);
    //doesn't send notification because it can directly send to the receiver function with no problems.
    // _recipeController.sink
    //     .add(RecipeEvent(recipe: recipe, eventType: RecEventType.add));
  }

  Future<List<Recipe>> getRecs({String query}) async {
    return await _recRepository.getAllRecs(query: query);
  }

  Future<Ingredient> getRec(int id) async {
    return await _recRepository.getRec(id);
  }

  Future<List<Recipe>> getFavoriteRecs({int count}) async {
    return await _recRepository.getFavoriteRecs(count: count);
  }

  Future<dynamic> deleteRec(Recipe recipe) async {
    return await _recRepository.deleteRecById(recipe.id);
    // _recipeController.sink
    //     .add(RecipeEvent(recipe: recipe, eventType: RecEventType.delete));
  }

  Future deleteAllRecs() async {
    return await _recRepository.deleteAllRecs();
  }

  disposeRecController() {
    _recipeController.close();
  }
}
