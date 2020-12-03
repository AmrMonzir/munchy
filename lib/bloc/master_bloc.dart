import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/helpers/firebase_helper.dart';
import 'package:munchy/model/ing_repo.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/rec_repo.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/model/user.dart';
import 'package:munchy/model/user_repo.dart';

enum IngEventType { add, delete, update }
enum RecEventType { add, delete }

User loggedInUser;

class MasterBloc implements BlocBase {
  //Get instance of the Repository
  final _ingRepository = IngredientRepository();
  final _recRepository = RecipeRepository();
  final _userRepository = UserRepository();

  final _ingredientController = StreamController<IngredientEvent>.broadcast();
  final _recipeController = StreamController<RecipeEvent>.broadcast();

  @override
  void dispose() {
    _ingredientController.close();
    _recipeController.close();
  }

  //================== INGREDIENT BLOC LOGIC =============================//

  StreamSubscription<IngredientEvent> registerToIngStreamController(event) {
    return _ingredientController.stream.listen(event);
  }

  Future<List<Ingredient>> getIngs({String query}) async {
    return await _ingRepository.getAllIngs(query: query);
  }

  Future<List<Ingredient>> getLocalIngs(
      {List<String> columns, String query}) async {
    return await _ingRepository.getLocalIngs(query: query, columns: columns);
  }

  Future<List<Ingredient>> getRandomEssentialIngs({int count}) async {
    return await _ingRepository.getRandomEssentialIngs(count: count);
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
  //
  // void addIngLocal(Ingredient ingredient) async {
  //   List<Ingredient> result = await getIngs();
  //   bool isFound = false;
  //   for (var element in result) {
  //     isFound = (element.name == ingredient.name) &&
  //             element.isAvailable == ingredient.isAvailable
  //         ? true
  //         : false;
  //   }
  //
  //   if (!isFound) {
  //     await _ingRepository.insertIng(ingredient);
  //     _ingredientController.sink.add(
  //         IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
  //   } else {
  //     await _ingRepository.updateIng(ingredient);
  //     _ingredientController.sink.add(IngredientEvent(
  //         ingredient: ingredient, eventType: IngEventType.update));
  //   }
  // }

  updateIng(Ingredient ingredient, bool updateWithNotification) async {
    await _ingRepository.updateIng(ingredient);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.update));

    //Sync all ings with firebase here
    FirebaseHelper fireBaseHelper = FirebaseHelper();
    List<Ingredient> allLocalIngs = await _ingRepository.getLocalIngs();
    fireBaseHelper.syncIngChangesToFirebase(ings: allLocalIngs);

    //check for ingredient threshold here
    Ingredient ingToCheckThreshold = await getIng(ingredient.id);
    bool hasCrossedThreshold = false;
    switch (ingToCheckThreshold.essentialUnit) {
      case "Number":
        hasCrossedThreshold = ingToCheckThreshold.nQuantity <
            ingToCheckThreshold.essentialThreshold;
        break;
      case "mg":
        hasCrossedThreshold = ingToCheckThreshold.kgQuantity <
            ingToCheckThreshold.essentialThreshold;
        break;
      case "ml":
        hasCrossedThreshold = ingToCheckThreshold.lrQuantity <
            ingToCheckThreshold.essentialThreshold;
        break;
    }
    if (hasCrossedThreshold && updateWithNotification) {
      // send notification to all house members
      List<String> ids = await fireBaseHelper.getFellowUsers();
      fireBaseHelper.sendNotification(ids, ingToCheckThreshold.name);
    }
  }

  deleteIng(Ingredient ingredient) async {
    await _ingRepository.deleteIngById(ingredient.id);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.delete));
  }

  deleteLocalIngs() async {
    await _ingRepository.deleteLocalIngs();
  }

  Future deleteAllIngs() async {
    return await _ingRepository.deleteAllIngs();
  }

  //================== RECIPE BLOC LOGIC =============================//
  StreamSubscription<RecipeEvent> registerToRecStreamController(event) {
    return _recipeController.stream.listen(event);
  }

  Future<dynamic> addRec(Recipe recipe, bool syncToFirebase) async {
    var a = await _recRepository.insertRec(recipe);
    _recipeController
        .add(RecipeEvent(eventType: RecEventType.add, recipe: recipe));

    //send this rec to this user's fav db
    if (syncToFirebase) {
      FirebaseHelper firebaseHelper = FirebaseHelper();
      firebaseHelper.syncUserRecipesToFirebase();
    }
    return a;
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
    recipe.isFavorite = false;
    var a = await _recRepository.deleteRecById(recipe.id);
    if (!_recipeController.isClosed) {
      _recipeController
          .add(RecipeEvent(eventType: RecEventType.delete, recipe: recipe));
    }

    FirebaseHelper firebaseHelper = FirebaseHelper();
    firebaseHelper.deleteThisRecipeFromFirebase(recipe);

    return a;
  }

  Future deleteAllRecs() async {
    return await _recRepository.deleteAllRecs();
  }

//================== USER BLOC LOGIC =============================//

  Future<AppUser> getUser(String id) async {
    return await _userRepository.getUser(id: id);
  }

  Future<int> storeUser(AppUser appUser) async {
    return await _userRepository.storeUser(appUser);
  }

  Future deleteUser(String id) async {
    return await _userRepository.deleteUser(id);
  }

  Future updateUser(AppUser user) async {
    return await _userRepository.updateUser(user);
  }
}
