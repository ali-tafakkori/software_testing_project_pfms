import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/user.dart';

@floor.dao
abstract class UserDao {
  @floor.insert
  Future<void> insert(User user);

  @floor.update
  Future<void> update(User user);

  @floor.Query('SELECT * FROM user WHERE username = :username AND password = :password')
  Future<User?> findByUsernameAndPassword(String username, String password);

  @floor.Query('SELECT * FROM user WHERE username = :username')
  Future<User?> findByUsername(String username);

  @floor.delete
  Future<void> delete(User user);
}
