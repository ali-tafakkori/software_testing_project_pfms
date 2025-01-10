import 'package:floor/floor.dart';

@entity
class Invoice {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int amount;
  final DateTime dateTime;
  final int userId;
  Invoice({
    this.id,
    required this.amount,
    required this.dateTime,
    required this.userId,
  });
}
