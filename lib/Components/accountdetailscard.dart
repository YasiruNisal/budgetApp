import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountDetailsCard extends StatelessWidget {
  final Function onPlusClick;
  final String imgPath;
  final double balance;
  final String accountName;
  final String currency;

  AccountDetailsCard({this.imgPath, this.accountName, this.balance, this.currency, this.onPlusClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => DetailsPage(heroTag: imgPath, foodName: foodName, foodPrice: price)
//              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Hero(tag: imgPath, child: Image(image: AssetImage(imgPath), fit: BoxFit.cover, height: 55.0, width: 55.0)),
                  ),
                  SizedBox(width: 10.0),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(currency + ' ' + formatMoney(balance),
                        style: TextStyle(
//                                        fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold)),
                    Text(accountName,
                        style: TextStyle(
//                                        fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey))
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
