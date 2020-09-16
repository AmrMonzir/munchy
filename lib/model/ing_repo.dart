import 'ing_dao.dart';
import 'ingredient.dart';

class IngredientRepository {
  final ingredientDao = IngredientsDao();

  Future getAllIngs({String query}) => ingredientDao.getIngs(query: query);

  Future insertIng(Ingredient ing) => ingredientDao.createIng(ing);

  Future updateIng(Ingredient ing) => ingredientDao.updateIng(ing);

  Future deleteIngById(int id) => ingredientDao.deleteIng(id);

  Future deleteAllIngs() => ingredientDao.deleteAllIngs();

  Future getIng(int id) => ingredientDao.getIng(id);
}
