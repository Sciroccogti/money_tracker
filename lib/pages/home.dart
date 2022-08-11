/*
 * @file home.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 21:48:00
 * @modified: 2022-08-10 21:48:20
 */

import 'package:flutter/material.dart';
import 'package:money_tracker/database/dbprovider.dart';
import 'package:money_tracker/vars.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (!isBillsInit) {
      _loadBills();
      isBillsInit = true;
    }
    return Scaffold(
      body: Center(
        child: Text("账单共有 $dbLength 条"),
      ),
      // TODO: testing SQL
      floatingActionButton: FloatingActionButton(
        heroTag: "refresh",
        onPressed: () => setState(() {
          _loadBills();
          build(context);
        }),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _loadBills() async {
    DBProvider provider = DBProvider.getInstance();
    dbLength = await provider.getLength();
  }
}
