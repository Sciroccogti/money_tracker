/*
 * @file home.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 21:48:00
 * @modified: 2022-08-13 23:19:35
 */

import 'package:flutter/material.dart';
import 'package:money_tracker/database/bill.dart';
import 'package:money_tracker/database/dbprovider.dart';
import 'package:money_tracker/pages/submit.dart';
import 'package:money_tracker/vars.dart';
import 'package:provider/provider.dart';

// https://flutter.cn/docs/development/data-and-backend/state-mgmt/simple
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<DBProvider>(
                builder: (context, database, child) =>
                    Text("共 ${database.billsLength} 条账单"),
              ),
            ],
          ),
          Expanded(
            child: _BillList(),
            // child: Consumer<DBProvider>(
            //   builder: (context, database, child) =>
            //       _BillList(), // TODO 双重 listen了
            // ),
          )
        ],
      ),
    );
  }
}

class _BillList extends StatefulWidget {
  const _BillList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BillListState();
}

class _BillListState extends State<_BillList> {
  List<Bill> bills_ = [];

  void fetchBills() async {
    DBProvider provider = DBProvider.getInstance();
    bills_ = await provider.getBills();
  }

  @override
  void initState() {
    super.initState();
    fetchBills();
  }

  @override
  Widget build(BuildContext context) {
    var dbWatcher = context.watch<DBProvider>();

    return AnimatedBuilder(
        animation: dbWatcher,
        builder: (BuildContext context, Widget? child) {
          return FutureBuilder<List<Bill>>(
            future: dbWatcher.getBills(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Bill>> snapshot) {
              print("build:");
              print(dbWatcher.billsLength);
              print(bills_.length);
              if (snapshot.hasData) {
                bills_ = snapshot.data!;
              }

              return ListView.builder(
                  itemCount: bills_.length,
                  itemBuilder: (context, index) {
                    String prefix = "";
                    switch (bills_[index].type) {
                      case 0:
                        prefix = "-";
                        break;
                      case 1:
                        prefix = "+";
                        break;
                    }

                    return ListTile(
                      title: Text(bills_[index].name),
                      leading: Icon(
                        categoryIcons_[dbWatcher.cates_[bills_[index].category]?.icon],
                        color: typeColors_[bills_[index].type],
                      ),
                      trailing: Text(
                        "$prefix${bills_[index].amount}",
                        style:
                            TextStyle(color: typeColors_[bills_[index].type]),
                      ),
                    );
                  });
            },
          );
        });
  }
}
