/*
 * @file home.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 21:48:00
 * @modified: 2022-08-13 16:08:55
 */

import 'package:flutter/material.dart';
import 'package:money_tracker/database/dbprovider.dart';
import 'package:money_tracker/vars.dart';
import 'package:provider/provider.dart';

// https://flutter.cn/docs/development/data-and-backend/state-mgmt/simple
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<DBProvider>(
          builder: (context, database, child) =>
              Text("共 ${database.length} 条账单"),
        ),
      ),
    );
  }
}
