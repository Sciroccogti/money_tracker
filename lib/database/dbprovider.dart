/*
 * @file dbprovider.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief ref: https://github.com/mCyp/flutter_hoo
 * @date 2022-08-10 23:42:38
 * @modified: 2022-08-10 23:42:50
 */

import 'bill.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // singleton
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() => _singleton;

  DBProvider._internal();

  static DBProvider getInstance() => _singleton;

  static Future<DBProvider> getInstanceAndInit() async {
    _db = await _singleton._initDB();
    return _singleton;
  }

  // DBProvider
  static late Database _db;

  Future<Database> get db async => _db;

  Future<Database> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "money_tracker.db");
    // open the database
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute("CREATE TABLE Bills ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "account INTEGER,"
          "type INTEGER,"
          "amount REAL,"
          "time INTEGER,"
          "name TEXT,"
          "category TEXT,"
          "originID INTEGER"
          ");");
    });
  }

// Future _onCreate(Database db, int version) async {}

  Future<int> getLength() async {
    Database database = await db;
    return Sqflite.firstIntValue(
            await database.rawQuery("SELECT COUNT(*) FROM Bills")) ??
        0;
  }

  void insertBill(Bill bill) async {
    Database database = await db;
    int id = await database.insert("Bills", bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  void insertBillRaw(Bill bill) async {
    Database database = await db;
    await database.rawInsert(
        "INSERT INTO Bills (id account type amount time name category origin)"
        "VALUES (?, ?, ?, ?, ?, ?);",
        [
          bill.id,
          bill.account,
          bill.type,
          bill.amount,
          bill.time,
          bill.name,
          bill.category,
          bill.originID
        ]);
    // insert("Bills", bill.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }
}
