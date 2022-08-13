/*
 * @file bill.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-10 21:56:29
 * @modified: 2022-08-13 16:12:53
 */

class Bill {
  int? id; // id: id of one bill, autoincrement
  int account; // account: default, alipay, wechat, credit card; store in INTEGER
  int type; // type: outlay, income, refund, deposit
  double amount; // amount: how much is the bill
  int time; // time: unix timestamp
  String name; // name: the name of goods and additional notes
  String category; // category: 数码，交通，娱乐，教育，理财，餐饮，日用，通讯，运动，化妆，住房，医疗，购物，etc
  int? originID; // originID: from imported bills, aimed at identifying refunding bills

  Bill(
    this.account,
    this.type,
    this.amount,
    this.time,
    this.name,
    this.category, {
    this.id, // must be null
    this.originID,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "account": account,
      "type": type,
      "amount": amount,
      "time": time,
      "name": name,
      "category": category,
      "originID": originID,
    };
  }
}
