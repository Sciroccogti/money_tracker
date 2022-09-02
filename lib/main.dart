/*
 * @file main.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 13:24:46
 * @modified: 2022-08-10 21:48:34
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_tracker/database/bill.dart';
import 'package:money_tracker/database/dbprovider.dart';
import 'package:money_tracker/pages/drawer.dart';
import 'package:money_tracker/pages/home.dart';
import 'package:money_tracker/pages/stats.dart';
import 'package:money_tracker/pages/submit.dart';
import 'package:money_tracker/vars.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
  });

  DBProvider provider = await DBProvider.getInstanceAndInit(); // TODO: ChangeNotifierProvider 也会实例化

  provider.fetchCates();

  runApp(ChangeNotifierProvider(
    create: (context) => DBProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColorDark,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColorDark,
        brightness: Brightness.dark
      ),
      themeMode: ThemeMode.system,
      home: MyStatefulWidget(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      locale: Locale('zh', 'CN'),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _curPageIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  List<Widget> bodyList_ = [];

  @override
  void initState() {
    bodyList_
      ..add(const HomePage())
      ..add(const StatsPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("redraw main!");
    return Scaffold(
      body: Center(
        child: bodyList_[_curPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _curPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 56,
        selectedIndex: _curPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: '账单',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart),
            // selectedIcon: Icon(Icons.camera_alt_outlined),
            label: '统计',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return SubmitPage();
              }));
        },
        tooltip: '记一笔',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
