/*
 * @file submit.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-11 16:51:29
 * @modified: 2022-08-11 16:51:53
 */

import 'package:flutter/material.dart';
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
        children: const <Widget>[
          Center(
            child: Text("It's cloudy here"),
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
