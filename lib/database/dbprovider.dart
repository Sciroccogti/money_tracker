/*
 * @file dbprovider.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief ref: https://github.com/mCyp/flutter_hoo
 * @date 2022-08-10 23:42:38
 * @modified: 2022-08-13 16:08:22
 */

import 'package:flutter/material.dart';

import 'bill.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DBProvider with ChangeNotifier {
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
  int length = 0;

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
      length = 0;
    }, onOpen: (Database db) async {
      length = Sqflite.firstIntValue(
              await db.rawQuery("SELECT COUNT(*) FROM Bills")) ??
          0;
    });
  }

// Future _onCreate(Database db, int version) async {}

  void insertBill(Bill bill) async {
    Database database = await db;
    int id = await database.insert("Bills", bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    length++;
    notifyListeners();
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
    length++;
    notifyListeners();
  }

  Future<List<Bill>> getBills() async {
    Database database = await db;
    List<Map<String, dynamic>> maps_ = await database.query(
      "Bills",
    );
    List<Bill> results_ = [];

    for (Map<String, dynamic> map in maps_) {
      results_.add(Bill.fromMap(map));
    }

    print("results_.length=");
    print(results_.length);

    return results_;
  }

// void getBillByTime() async {
//   DateTime.now().millisecondsSinceEpoch;
// }
}
