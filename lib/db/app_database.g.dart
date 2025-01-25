// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  CustomerDao? _customerDaoInstance;

  InvoiceDao? _invoiceDaoInstance;

  ChargeDao? _chargeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `balance` INTEGER NOT NULL, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Customer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `balance` INTEGER NOT NULL, `userId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Invoice` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `amount` INTEGER NOT NULL, `dateTime` TEXT NOT NULL, `customerId` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `photo` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Charge` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `customerId` INTEGER NOT NULL, `amount` INTEGER NOT NULL, `dateTime` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  CustomerDao get customerDao {
    return _customerDaoInstance ??= _$CustomerDao(database, changeListener);
  }

  @override
  InvoiceDao get invoiceDao {
    return _invoiceDaoInstance ??= _$InvoiceDao(database, changeListener);
  }

  @override
  ChargeDao get chargeDao {
    return _chargeDaoInstance ??= _$ChargeDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'balance': item.balance,
                  'name': item.name
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'balance': item.balance,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<void> updateNameById(
    String name,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn('UPDATE user SET name = ?1 WHERE id = ?2',
        arguments: [name, id]);
  }

  @override
  Future<void> updateUsernameById(
    String username,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE user SET username = ?1 WHERE id = ?2',
        arguments: [username, id]);
  }

  @override
  Future<void> updatePasswordById(
    String password,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE user SET password = ?1 WHERE id = ?2',
        arguments: [password, id]);
  }

  @override
  Future<User?> findByUsernameAndPassword(
    String username,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM user WHERE username = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            balance: row['balance'] as int,
            name: row['name'] as String),
        arguments: [username, password]);
  }

  @override
  Future<User?> findByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM user WHERE username = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            balance: row['balance'] as int,
            name: row['name'] as String),
        arguments: [username]);
  }

  @override
  Future<User?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            balance: row['balance'] as int,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<int?> count() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM user',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insert(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> delete(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$CustomerDao extends CustomerDao {
  _$CustomerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerInsertionAdapter = InsertionAdapter(
            database,
            'Customer',
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'balance': item.balance,
                  'userId': item.userId
                }),
        _customerUpdateAdapter = UpdateAdapter(
            database,
            'Customer',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'balance': item.balance,
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Customer> _customerInsertionAdapter;

  final UpdateAdapter<Customer> _customerUpdateAdapter;

  @override
  Future<List<Customer>> findByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM customer WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            balance: row['balance'] as int,
            userId: row['userId'] as int),
        arguments: [userId]);
  }

  @override
  Future<Customer?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM customer WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            balance: row['balance'] as int,
            userId: row['userId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> chargeBalanceById(
    int amount,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE customer SET balance = balance + ?1 WHERE id = ?2',
        arguments: [amount, id]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM customer WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> countByUserId(int userId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM customer WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId]);
  }

  @override
  Future<void> insert(Customer customer) async {
    await _customerInsertionAdapter.insert(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Customer customer) async {
    await _customerUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }
}

class _$InvoiceDao extends InvoiceDao {
  _$InvoiceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _invoiceInsertionAdapter = InsertionAdapter(
            database,
            'Invoice',
            (Invoice item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'customerId': item.customerId,
                  'userId': item.userId,
                  'photo': item.photo
                }),
        _invoiceUpdateAdapter = UpdateAdapter(
            database,
            'Invoice',
            ['id'],
            (Invoice item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'customerId': item.customerId,
                  'userId': item.userId,
                  'photo': item.photo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Invoice> _invoiceInsertionAdapter;

  final UpdateAdapter<Invoice> _invoiceUpdateAdapter;

  @override
  Future<List<Invoice>> findByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM invoice WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Invoice(
            id: row['id'] as int?,
            amount: row['amount'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as String),
            customerId: row['customerId'] as int,
            userId: row['userId'] as int,
            photo: row['photo'] as String?),
        arguments: [userId]);
  }

  @override
  Future<Invoice?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM invoice WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Invoice(
            id: row['id'] as int?,
            amount: row['amount'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as String),
            customerId: row['customerId'] as int,
            userId: row['userId'] as int,
            photo: row['photo'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> updatePhotoById(
    String photo,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE invoice SET photo = ?1 WHERE id = ?2',
        arguments: [photo, id]);
  }

  @override
  Future<void> removePhotoById(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE invoice SET photo = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM invoice WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteByCustomerId(int customerId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM invoice WHERE customerId = ?1',
        arguments: [customerId]);
  }

  @override
  Future<void> insert(Invoice invoice) async {
    await _invoiceInsertionAdapter.insert(invoice, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Invoice invoice) async {
    await _invoiceUpdateAdapter.update(invoice, OnConflictStrategy.abort);
  }
}

class _$ChargeDao extends ChargeDao {
  _$ChargeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _chargeInsertionAdapter = InsertionAdapter(
            database,
            'Charge',
            (Charge item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'amount': item.amount,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                }),
        _chargeUpdateAdapter = UpdateAdapter(
            database,
            'Charge',
            ['id'],
            (Charge item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'amount': item.amount,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Charge> _chargeInsertionAdapter;

  final UpdateAdapter<Charge> _chargeUpdateAdapter;

  @override
  Future<List<Charge>> findByCustomerId(int customerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM charge WHERE customerId = ?1 ORDER BY dateTime DESC',
        mapper: (Map<String, Object?> row) => Charge(
            id: row['id'] as int?,
            customerId: row['customerId'] as int,
            amount: row['amount'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as String)),
        arguments: [customerId]);
  }

  @override
  Future<Charge?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM charge WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Charge(
            id: row['id'] as int?,
            customerId: row['customerId'] as int,
            amount: row['amount'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM charge WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteByCustomerId(int customerId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM charge WHERE customerId = ?1',
        arguments: [customerId]);
  }

  @override
  Future<void> insert(Charge charge) async {
    await _chargeInsertionAdapter.insert(charge, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Charge charge) async {
    await _chargeUpdateAdapter.update(charge, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
