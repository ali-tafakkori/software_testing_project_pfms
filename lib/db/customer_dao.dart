import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/customer.dart';

@floor.dao
abstract class CustomerDao {
  @floor.insert
  Future<void> insert(Customer customer);

  @floor.update
  Future<void> update(Customer customer);

  @floor.delete
  Future<void> delete(Customer customer);
}
