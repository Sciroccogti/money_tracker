/*
 * @file dbprovider.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief ref: https://github.com/mCyp/flutter_hoo
 * @date 2022-08-10 23:42:38
 * @modified: 2022-08-13 16:08:22
 */

import 'bill.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'category.dart';

List<Category> _defaultCategories_ = [
  Category("数码", "数码-手机"),
  Category("工资", "工资条"),
  Category("交通", "公交"),
  Category("娱乐", "娱乐设施"),
  Category("教育", "教育"),
  Category("理财", "理财"),
  Category("餐饮", "餐饮"),
  Category("日用", "日用"),
  Category("通讯", "通讯"),
  Category("运动", "棒球"),
  Category("化妆", "化妆品"),
  Category("住房", "住房"),
  Category("医疗", "医疗"),
  Category("购物", "购物"),
];

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
  int billsLength = 0;
  Map<String, Category> cates_ = {};

  Future<Database> get db async => _db;

  Future<Database> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "money_tracker.db");
    // open the database
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      // Table Bill
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
      // Table Categories
      await db.execute("CREATE TABLE Categories ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "category TEXT,"
          "type INTEGER,"
          "icon TEXT"
          ");");

      for (Category cate in _defaultCategories_) {
        int id = await db.insert("Categories", cate.toMap(),
            conflictAlgorithm: ConflictAlgorithm.fail);
      }
      billsLength = 0;
    }, onOpen: (Database db) async {
      billsLength = Sqflite.firstIntValue(
              await db.rawQuery("SELECT COUNT(*) FROM Bills")) ??
          0;
    });
  }

// Future _onCreate(Database db, int version) async {}

  void insertBill(Bill bill) async {
    Database database = await db;
    int id = await database.insert("Bills", bill.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    billsLength++;
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
    billsLength++;
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

    return results_;
  }

  Future<List<Bill>> getBillByRange(DateTimeRange range) async {
    Database database = await db;
    List<Map<String, dynamic>> maps_ = await database.query("Bills",
        where: "time >= ? and time <= ?",
        whereArgs: [
          range.start.millisecondsSinceEpoch,
          range.end.millisecondsSinceEpoch
        ]);

    List<Bill> results_ = [];
    for (Map<String, dynamic> map in maps_) {
      results_.add(Bill.fromMap(map));
    }

    return results_;
  }

  void fetchCates() async {
    DBProvider provider = DBProvider.getInstance();
    cates_ = await provider.getCategories();
  }

  void insertCategory(Category cate) async {
    Database database = await db;
    int id = await database.insert("Categories", cate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    notifyListeners(); // TODO: should we?
  }

  Future<Map<String, Category>> getCategories() async {
    Database database = await db;
    List<Map<String, dynamic>> maps_ = await database.query(
      "Categories",
    );
    Map<String, Category> results_ = {};

    for (Map<String, dynamic> map in maps_) {
      Category cate = Category.fromMap(map);
      results_[cate.category] = cate;
    }

    return results_;
  }
}
