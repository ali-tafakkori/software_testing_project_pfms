import 'package:floor/floor.dart';

@entity
class Purchase {
  final int amount;
  final DateTime dateTime;
  final int customerId;
  Purchase({
    required this.amount,
    required this.dateTime,
    required this.customerId,
  });
}