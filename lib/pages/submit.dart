/*
 * @file submit.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-11 16:51:29
 * @modified: 2022-08-11 16:51:53
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/database/bill.dart';
import 'package:money_tracker/database/dbprovider.dart';
import 'package:money_tracker/vars.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Bill bill = Bill(-1, -1, -1, -1, "", "");

    return Scaffold(
      appBar: AppBar(
        title: Text("新增账单"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          indicatorColor: secondaryColor,
          controller: _tabController,
          tabs: [
            Tab(
              text: "支出",
            ),
            Tab(
              text: "收入",
            ),
            Tab(
              text: "转账",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "备注",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value != null) {
                        bill.name = value;
                        return null;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "金额",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value != null) {
                        bill.amount = double.tryParse(value) ?? 0;
                        if (bill.amount == 0) {
                          return "请输入正确的金额！";
                        }
                        return null;
                      } else {
                        return "请输入正确的金额！";
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9,\.]"))
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    DBProvider provider = DBProvider.getInstance();
                    provider.insertBill(bill);
                  },
                  child: Icon(Icons.check),
                )
              ],
            ),
          ),
          Center(
            child: Text("It's rainy here"),
          ),
          Center(
            child: Text("It's sunny here"),
          ),
        ],
      ),
    );
  }
}
