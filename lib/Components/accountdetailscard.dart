import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplybudget/config/colors.dart';

class AccountDetailsCard extends StatelessWidget {
  final Function onPlusClick;
  final Function onTap;
  final String imgPath;
  final double balance;
  final String accountName;
  final String currency;

  AccountDetailsCard({this.imgPath, this.accountName, this.balance, this.currency, this.onPlusClick, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
//                        Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Hero(tag: imgPath, child: Image(image: AssetImage(imgPath), fit: BoxFit.cover, height: 55.0, width: 55.0)),
//                        ),
                      SizedBox(width: 10.0),
                      Container(
                        decoration: new BoxDecoration(
                          color: MyColors.ExpenseCategory8,
                          borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                        ),
                        height: 55,
                        width: 55,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Image.asset(imgPath),
                          ),
                        ),
                      ),
                        SizedBox(width: 10.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: 190,
                            child: Text(currency + ' ' + formatMoney(balance),
                                style: TextStyle(
                                    fontSize: 25.0,
                                    )),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: 190,
                            child: Text(
                              accountName,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey),
                              textAlign: TextAlign.left,
                            ),
                          ),
                  ])
                ])),
                IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () {
                      onPlusClick();
                    })
              ],
            )));
  }

  String formatMoney(double val) {
    NumberFormat format = NumberFormat('#,###,###.##');
    return format.format(val).toString();
  }
}
