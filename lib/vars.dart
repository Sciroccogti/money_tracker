/*
 * @file vars.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 22:16:26
 * @modified: 2022-08-13 16:08:07
 */

import 'package:flutter/material.dart';

// from ./pubspec.yaml
String appName = "";
String packageName = "";
String appVersion = "";
Color primaryColor = Colors.lightBlue.shade900;
Color secondaryColor = Colors.lightBlue.shade50;
Color primaryColorDark = Colors.blue.shade200;
Color secondaryColorDark = Colors.lightBlue.shade900;
List<Color> typeColors_ = [Colors.red, Colors.green, Colors.blue];

const Map<String, IconData> categoryIcons_ = {
  "工资条": IconData(0xe60f, fontFamily: "IconFont"),
  "数码-手机": IconData(0xe609, fontFamily: "IconFont"),
  "公交": IconData(0xe601, fontFamily: "IconFont"),
  "娱乐设施": IconData(0xe608, fontFamily: "IconFont"),
  "教育": IconData(0xe60a, fontFamily: "IconFont"),
  "理财": IconData(0xe7e9, fontFamily: "IconFont"),
  "餐饮": IconData(0xe607, fontFamily: "IconFont"),
  "日用": IconData(0xe7ef, fontFamily: "IconFont"),
  "通讯": IconData(0xe7f0, fontFamily: "IconFont"),
  "棒球": IconData(0xe601, fontFamily: "IconFont"),
  "化妆品": IconData(0xe60e, fontFamily: "IconFont"),
  "住房": IconData(0xe7f2, fontFamily: "IconFont"),
  "医疗": IconData(0xe7f1, fontFamily: "IconFont"),
  "购物": IconData(0xe7ed, fontFamily: "IconFont"),
};

int dbLength = 0;
