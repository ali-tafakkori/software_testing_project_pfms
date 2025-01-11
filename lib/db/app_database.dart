import 'dart:async';
import 'package:floor/floor.dart';
import 'package:software_testing_project_pfms/db/converters/date_time_converter.dart';
import 'package:software_testing_project_pfms/db/customer_dao.dart';
import 'package:software_testing_project_pfms/db/invoice_dao.dart';
import 'package:software_testing_project_pfms/db/user_dao.dart';
import 'package:software_testing_project_pfms/models/customer.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';
import 'package:software_testing_project_pfms/models/user.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([
  DateTimeConverter,
])
@Database(version: 1, entities: [
  User,
  Customer,
  Invoice,
])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

  CustomerDao get customerDao;

  InvoiceDao get invoiceDao;

  static late AppDatabase _appDatabase;

  static AppDatabase get instance {
    return _appDatabase;
  }

  static const String _dbName = "app_database.db";

  static Future<void> init() async {
    _appDatabase = await $FloorAppDatabase.databaseBuilder(_dbName).build();
  }

  Future<double> profit(int userId) async {
    var result = await database.rawQuery(
      //"SELECT (IFNULL((SELECT SUM(balance) FROM customer WHERE userId = ?1), 0) - IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0) - (IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0) * 0.1)) AS profit",
      "SELECT (IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0) * 0.1) AS profit",
      [
        userId,
      ],
    );
    var row = result.first.values.first ?? 0;
    double i = row as double;
    return i;
  }

  Future<int> debt(int userId) async {
    var result = await database.rawQuery(
      "SELECT (IFNULL((SELECT SUM(balance) FROM customer WHERE userId = ?1), 0) - IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0)) AS difference",
      [
        userId,
      ],
    );
    var row = result.first.values.first ?? 0;
    int i = row as int;
    return i;
  }
}
