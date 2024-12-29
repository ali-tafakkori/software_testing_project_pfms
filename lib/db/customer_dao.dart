import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/customer.dart';

@floor.dao
abstract class CustomerDao {
  @floor.Query('SELECT * FROM customer')
  Future<List<Customer>> findAll();
  @floor.Query('SELECT * FROM user WHERE id = :id')
  Future<Customer?> findById(int id);
  @floor.insert
  Future<void> insert(Customer customer);

  @floor.update
  Future<void> update(Customer customer);

  @floor.Query('DELETE FROM customer WHERE id = :id')
  Future<void> deleteById(int id);

  @floor.Query('SELECT COUNT(*) FROM customer')
  Future<int?> count();
}
