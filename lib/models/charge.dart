import 'package:floor/floor.dart';

@entity
class Charge {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int customerId;
  final int amount;
  final int userId;

  const Charge({
    this.id,
    required this.customerId,
    required this.amount,
    required this.userId,
  });
}
