import 'dart:async';
import 'package:floor/floor.dart';
import 'package:software_testing_project_pfms/db/customer_dao.dart';
import 'package:software_testing_project_pfms/db/invoice_dao.dart';
import 'package:software_testing_project_pfms/db/user_dao.dart';
import 'package:software_testing_project_pfms/models/customer.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';
import 'package:software_testing_project_pfms/models/user.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

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
}
