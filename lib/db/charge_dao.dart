import 'package:floor/floor.dart' as floor;
import 'package:software_testing_project_pfms/models/charge.dart';

@floor.dao
abstract class ChargeDao {
  @floor.Query('SELECT * FROM charge WHERE customerId = :customerId ORDER BY dateTime DESC')
  Future<List<Charge>> findByCustomerId(int customerId);

  @floor.Query('SELECT * FROM charge WHERE id = :id')
  Future<Charge?> findById(int id);

  @floor.insert
  Future<void> insert(Charge charge);

  @floor.update
  Future<void> update(Charge charge);

  @floor.Query('DELETE FROM charge WHERE id = :id')
  Future<void> deleteById(int id);

  @floor.Query('SELECT COUNT(*) FROM charge WHERE customerId = :customerId')
  Future<int?> countByCustomerId(int customerId);
}
