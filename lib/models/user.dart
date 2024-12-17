import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String username;
  final String password;
  final int balance;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.balance,
  });
}
