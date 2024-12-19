import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String username;
  final String password;
  final int balance;
  final String name;

  User({
    this.id,
    required this.username,
    required this.password,
    this.balance = 0,
    required this.name,
  });
}
