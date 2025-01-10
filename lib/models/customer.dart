import 'package:floor/floor.dart';

@entity
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int balance;
  final int userId;

  const Customer({
    this.id = -1,
    required this.name,
    this.balance = 0,
    required this.userId,
  });
}
