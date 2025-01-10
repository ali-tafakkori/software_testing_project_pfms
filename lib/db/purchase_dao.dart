import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/purchase.dart';
import 'package:software_testing_project_pfms/models/user.dart';

@floor.dao
abstract class PurchaseDao {
  @floor.Query('SELECT * FROM user WHERE username = :username AND password = :password')
  Future<List<Purchase>> findByUserId(String username, String password);
}
