/*
 * @file category.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-20 14:50:18
 * @modified: 2022-08-20 14:50:29
 */

import 'package:flutter/foundation.dart';

class Category {
  int? id; // id: id of one category, autoincrement
  String category; // category: name of category
  int? type; // type: same with Bill, if null then show in all types
  String icon; // icon: String in _categoryIcons_

  Category(
    this.category,
    this.icon, {
    this.id,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "category": category,
      "type": type,
      "icon": icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    Category cate = Category(map["category"], map["icon"]);
    if (map["id"] != null) {
      cate.id = map["id"];
    }
    if (map["type"] != null) {
      cate.id = map["type"];
    }

    return cate;
  }
}
