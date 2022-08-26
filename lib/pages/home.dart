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
          const Expanded(
            child: _BillCardsColumn(),
          ),
        ],
      ),
    );
  }
}

class _BillCardsColumn extends StatelessWidget {
  const _BillCardsColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List<Widget> cardChild = [];
    for (int day = 1; day <= now.day; day++) {
      DateTimeRange range = DateTimeRange(
          start: DateTime(now.year, now.month, day),
          end: DateTime(now.year, now.month, day, 23, 59, 59));
      cardChild.add(_BillCard(range: range));
    }

    return ListView(padding: const EdgeInsets.all(10), children: cardChild);
  }
}

class _BillCard extends StatefulWidget {
  const _BillCard({Key? key, required this.range}) : super(key: key);

  final DateTimeRange range;

  @override
  State<StatefulWidget> createState() => _BillCardState();
}

class _BillCardState extends State<_BillCard> {
  List<Bill> bills_ = [];
  double incomeSum = 0;
  double outlaySum = 0;

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
    DateTimeRange range = widget.range;

    return AnimatedBuilder(
        animation: dbWatcher,
        builder: (BuildContext context, Widget? child) {
          return FutureBuilder<List<Bill>>(
            future: dbWatcher.getBillByRange(range),
            builder:
                (BuildContext context, AsyncSnapshot<List<Bill>> snapshot) {
              if (snapshot.hasData) {
                bills_ = snapshot.data!;
                print("${range.start.day} ${range.start.hour}");
                print("hasData: ${bills_.length}");
                for (Bill bill in bills_) {
                  if (bill.type == BillType.income.index) {
                    incomeSum += bill.amount;
                  } else if (bill.type == BillType.outlay.index) {
                    outlaySum += bill.amount;
                  }
                }
              }
              if (bills_.isEmpty) {
                return const SizedBox.shrink();
              }
              return Card(
                  child: Column(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${range.start.month}月${range.start.day}日 ${chineseWeek[range.start.weekday]}"),
                        Text("支:${outlaySum.toStringAsFixed(2)}"),
                        Text("收:${incomeSum.toStringAsFixed(2)}"),
                      ],
                    )),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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
                          categoryIcons_[
                              dbWatcher.cates_[bills_[index].category]?.icon],
                          color: typeColors_[bills_[index].type],
                        ),
                        trailing: Text(
                          "$prefix${bills_[index].amount}",
                          style:
                              TextStyle(color: typeColors_[bills_[index].type]),
                        ),
                      );
                    })
              ]));
            },
          );
        });
  }
}
