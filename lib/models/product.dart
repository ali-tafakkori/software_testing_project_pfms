import 'package:floor/floor.dart';

@entity
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  Product({
    this.id,
    required this.name,
  });
}
