import 'package:floor/floor.dart';

@entity
class Purchase {
  final int amount;
  final DateTime dateTime;
  final int userId;
  Purchase({
    required this.amount,
    required this.dateTime,
    required this.userId,
  });
}