import 'package:floor/floor.dart';

@entity
class Invoice {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int amount;
  final DateTime dateTime;
  final int customerId;
  final int userId;
  final String? photo;
  Invoice({
    this.id,
    required this.amount,
    required this.dateTime,
    required this.customerId,
    required this.userId,
     this.photo,
  });
}
