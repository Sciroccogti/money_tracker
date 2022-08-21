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
import 'package:money_tracker/database/category.dart';
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
  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime.now()); // 选中的日期
  String _selectedCategoryName = "";

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

  Widget buildCategoryList(int tabIndex) {
    DBProvider provider = DBProvider.getInstance();
    Iterator<Category> cateIter = provider.cates_.values.iterator;

    return GridView.builder(
        itemCount: provider.cates_.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 80),
        itemBuilder: (context, index) {
          cateIter.moveNext();
          Category curCate = cateIter.current;

          return GridTile(
            footer: Center(
                child: Text(
              curCate.category,
              style: TextStyle(
                color: _selectedCategoryName == curCate.category
                    ? typeColors_[tabIndex]
                    : Theme.of(context).disabledColor,
              ),
            )),
            child: TextButton(
              child: Icon(
                categoryIcons_[provider.cates_[curCate.category]?.icon],
                color: _selectedCategoryName == curCate.category
                    ? typeColors_[tabIndex]
                    : Theme.of(context).disabledColor,
              ),
              onPressed: () {
                _selectedCategoryName = curCate.category;
                setState(() {
                  build(context);
                });
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Bill bill = Bill(-1, -1, -1, -1, "", "");
    String dateString = _selectedDate.value.toString();
    DateTime now = DateTime.now();
    DateTime date = _selectedDate.value;
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      dateString =
          '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year != now.year) {
      dateString =
          '${date.year}-${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      dateString =
          '${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          title: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "支出"),
              Tab(text: "收入"),
              Tab(text: "转账"),
            ],
          ),
        ),
        body: GridView.extent(
          physics: const NeverScrollableScrollPhysics(),
          maxCrossAxisExtent: 540,
          children: [
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                buildCategoryList(0),
                buildCategoryList(1),
                buildCategoryList(2),
              ],
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _restorableDatePickerRouteFuture.present();
                      },
                      child: Text(dateString),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          hintText: "0.0",
                          border: InputBorder.none,
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "备注",
                          border: InputBorder.none,
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
                    ElevatedButton(
                      onPressed: () {
                        DBProvider provider = DBProvider.getInstance();
                        if (bill.amount > 0 &&
                            provider.cates_
                                .containsKey(_selectedCategoryName)) {
                          bill.category = _selectedCategoryName;
                          bill.type = _tabController.index;
                          bill.time =
                              _selectedDate.value.millisecondsSinceEpoch;
                          provider.insertBill(bill);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Icon(Icons.check),
                    )
                  ],
                ),
              ]),
            )
          ],
        ));
  }
}
