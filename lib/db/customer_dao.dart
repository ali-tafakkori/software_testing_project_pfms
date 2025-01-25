import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/customer.dart';

@floor.dao
abstract class CustomerDao {
  @floor.Query('SELECT * FROM customer WHERE userId = :userId')
  Future<List<Customer>> findByUserId(int userId);

  @floor.Query('SELECT * FROM customer WHERE id = :id')
  Future<Customer?> findById(int id);

  @floor.insert
  Future<int> insert(Customer customer);

  @floor.update
  Future<void> update(Customer customer);

  @floor.Query('UPDATE customer SET balance = balance + :amount WHERE id = :id')
  Future<void> chargeBalanceById(int amount, int id);

  @floor.Query('DELETE FROM customer WHERE id = :id')
  Future<void> deleteById(int id);

  @floor.Query('SELECT COUNT(*) FROM customer WHERE userId = :userId')
  Future<int?> countByUserId(int userId);
}
