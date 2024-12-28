import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/user.dart';

@floor.dao
abstract class UserDao {
  @floor.insert
  Future<void> insert(User user);

  @floor.update
  Future<void> update(User user);

  @floor.Query('SELECT * FROM user WHERE username = :user AND password = :pass')
  Future<User?> findByUserAndPass(String user, String pass);

  @floor.delete
  Future<void> delete(User user);
}
