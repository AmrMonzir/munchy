import 'package:munchy/model/rec_dao.dart';
import 'recipe.dart';

class RecipeRepository {
  final recipeDao = RecipesDao();

  Future getAllRecs({String query}) => recipeDao.getRecs(query: query);

  Future insertRec(Recipe rec) => recipeDao.createRec(rec);

  Future deleteRecById(int id) => recipeDao.deleteRec(id);

  Future deleteAllRecs() => recipeDao.deleteAllRecs();

  Future getRec(int id) => recipeDao.getRec(id);
}
