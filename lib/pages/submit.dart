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
  const SubmitPage({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  State<StatefulWidget> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage>
    with TickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now()); // 选中的日期

  @override
  String? get restorationId => widget.restorationId;
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: (DateTime? newSelectedDate) {
      if (newSelectedDate != null) {
        setState(() {
          _selectedDate.value = newSelectedDate;
        });
      }
    },
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1999),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  // restore the date as selected
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

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
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Row(
                    children: [Text("It's cloudy here")],
                  ),
                  Row(
                    children: [Text("It's rainy here")],
                  ),
                  Row(
                    children: [Text("It's sunny here")],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: Text(_selectedDate.value.toString()))
              ],
            ),
            Row(
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
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "金额",
                      // fillColor: typeColors_[_tabController.index],
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
                    if (bill.amount > 0) {
                      bill.type = _tabController.index;
                      bill.time = _selectedDate.value.millisecondsSinceEpoch;
                      provider.insertBill(bill);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(Icons.check),
                )
              ],
            ),
          ],
        ));
  }
}
