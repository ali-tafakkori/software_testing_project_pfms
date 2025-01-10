import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/invoice.dart';

@floor.dao
abstract class InvoiceDao {
  @floor.Query('SELECT * FROM invoice WHERE userId = :userId')
  Future<List<Invoice>> findByUserId(int userId);

  @floor.Query('SELECT * FROM invoice WHERE id = :id')
  Future<Invoice?> findById(int id);

  @floor.insert
  Future<void> insert(Invoice invoice);

  @floor.update
  Future<void> update(Invoice invoice);

  @floor.Query('DELETE FROM invoice WHERE id = :id')
  Future<void> deleteById(int id);

  @floor.Query('SELECT COUNT(*) FROM invoice WHERE userId = :userId')
  Future<int?> countByUserId(int userId);
}
