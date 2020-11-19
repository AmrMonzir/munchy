import 'user_dao.dart';
import 'user.dart';

class UserRepository {
  final userDao = UserDao();

  Future<AppUser> getUser({String id}) => userDao.getUser(id);

  Future<int> storeUser(AppUser user) => userDao.storeUser(user);

  Future<int> deleteUser(String id) => userDao.deleteUser(id);

  Future<int> updateUser(AppUser user) => userDao.updateUser(user);
}
