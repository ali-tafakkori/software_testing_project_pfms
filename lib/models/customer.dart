import 'package:floor/floor.dart';

@entity
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int balance;
  Customer({
    this.id,
    required this.name,
    required this.balance,
  });
}
