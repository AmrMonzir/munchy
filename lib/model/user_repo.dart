import 'user_dao.dart';
import 'user.dart';

class UserRepository {
  final userDao = UserDao();

  Future<AppUser> getUser({int id}) => userDao.getUser(id);

  Future<int> storeUser(AppUser user) => userDao.storeUser(user);

  Future<int> deleteUser(int id) => userDao.deleteUser(id);
}
