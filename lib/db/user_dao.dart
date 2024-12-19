import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/user.dart';

@floor.dao
abstract class UserDao {
  @floor.insert
  Future<void> insert(User user);

  @floor.update
  Future<void> update(User user);

  @floor.delete
  Future<void> delete(User user);
}
