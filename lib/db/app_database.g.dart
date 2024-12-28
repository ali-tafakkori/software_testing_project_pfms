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
            'CREATE TABLE IF NOT EXISTS `Customer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `balance` INTEGER NOT NULL)');

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
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
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

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User?> findByUserAndPass(
    String user,
    String pass,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM user WHERE username = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            balance: row['balance'] as int,
            name: row['name'] as String),
        arguments: [user, pass]);
  }

  @override
  Future<void> insert(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
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
  )   : _customerInsertionAdapter = InsertionAdapter(
            database,
            'Customer',
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'balance': item.balance
                }),
        _customerUpdateAdapter = UpdateAdapter(
            database,
            'Customer',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'balance': item.balance
                }),
        _customerDeletionAdapter = DeletionAdapter(
            database,
            'Customer',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'balance': item.balance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Customer> _customerInsertionAdapter;

  final UpdateAdapter<Customer> _customerUpdateAdapter;

  final DeletionAdapter<Customer> _customerDeletionAdapter;

  @override
  Future<void> insert(Customer customer) async {
    await _customerInsertionAdapter.insert(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Customer customer) async {
    await _customerUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> delete(Customer customer) async {
    await _customerDeletionAdapter.delete(customer);
  }
}
