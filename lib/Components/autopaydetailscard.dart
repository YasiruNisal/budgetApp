import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';

class AutoPayDetailCard extends StatelessWidget {
//  final Function onPlusClick;
  final FirebaseUser user;
  final String id;
  final String currency;
  final double autoPayAmount;
  final String autoPayName;
  final int autoPayStartDate;
  final int autoPayResetDate;
  final int autoPayRepeat;
  final double normalAccountBalance;
  final Function(String, String, double, int, int, int) onEditClick;
  final Function(String) onDeleteClick;

//  final String currency;

  AutoPayDetailCard(
      {this.user,
      this.id,
      this.normalAccountBalance,
      this.currency,
      this.autoPayName,
      this.autoPayAmount,
      this.onEditClick,
      this.autoPayStartDate,
      this.autoPayResetDate,
      this.autoPayRepeat,
      this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    int today = DateTime.now().millisecondsSinceEpoch;
    int resetDate = autoPayResetDate;
    if (resetDate == null) {
      resetDate = today;
    }
    //TODO
    if (today > resetDate) {
      resetAutoPay();
    }

    int year = DateTime.fromMillisecondsSinceEpoch(autoPayResetDate).year;
    int month = DateTime.fromMillisecondsSinceEpoch(autoPayResetDate).month;
    int day = DateTime.fromMillisecondsSinceEpoch(autoPayResetDate).day;

    return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 15.0, bottom: 10.0),

          child: InkWell(
              onTap: () {
//                onCardTap(id, budgetName, budgetLimit, budgetSpent, budgetStartDate, budgetRepeat);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Column(children: [
                    SizedBox(width: 20.0),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 5.0),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 120,
                        child: Text(autoPayName[0].toUpperCase() + autoPayName.substring(1), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 70,
                        child: Text(currency + " " + autoPayAmount.toStringAsFixed(2), style: TextStyle(fontSize: 20.0, color: Colors.black)),
                      ),
                    ]),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 180,
                      child: Text("Next Due : " + day.toString() + "/" + month.toString() + "/" + year.toString(), style: TextStyle(fontSize: 15.0, color: Colors.grey)),
                    ),
                  ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.black54,
                          onPressed: () {
                            onEditClick(
                              id,
                              autoPayName,
                              autoPayAmount,
                              autoPayStartDate,
                              autoPayRepeat,
                              resetDate,
                            );
                          }),
                      IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.black54,
                          onPressed: () {
                            onDeleteClick(
                              id,
                            );
                          }),
                    ],
                  )
                ],
              ))),
    );
  }

  void resetAutoPay() {
    int today = DateTime.now().millisecondsSinceEpoch;
    Map duration = returnBudgetDuration(autoPayRepeat);
    int resetDate = autoPayResetDate;


    while (resetDate < today) {

      dynamic result = FireStoreService(uid: user.uid).addAutoPayHistory(autoPayName,autoPayAmount,resetDate, normalAccountBalance);

      DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(resetDate).year, DateTime.fromMillisecondsSinceEpoch(resetDate).month, DateTime.fromMillisecondsSinceEpoch(resetDate).day);
      var jiffyTime = Jiffy(dt);

      if (duration["period"] == "days") {
        resetDate = jiffyTime.add(days: duration["time"]).millisecondsSinceEpoch;
      } else if (duration["period"] == "months") {
        resetDate = jiffyTime
            .add(
              months: duration["time"],
            )
            .millisecondsSinceEpoch;
      } else if (duration["period"] == "years") {
        resetDate = jiffyTime
            .add(
              years: duration["time"],
            )
            .millisecondsSinceEpoch;
      }


    }

      print("do we come here tooo");
    dynamic result = FireStoreService(uid: user.uid).resetAutoPay(id, autoPayAmount, resetDate);
  }

  Map returnBudgetDuration(int repeatPeriod) {
    switch (repeatPeriod) {
      case 0:
        return {"period": "days", "time": 1};
        break;
      case 1:
        return {"period": "days", "time": 2};
        break;
      case 2:
        return {"period": "days", "time": 7};
        break;
      case 3:
        return {"period": "days", "time": 14};
        break;
      case 4:
        return {"period": "days", "time": 28};
        break;
      case 5:
        return {"period": "months", "time": 1};
        break;
      case 6:
        return {"period": "months", "time": 2};
        break;
      case 7:
        return {"period": "months", "time": 3};
        break;
      case 8:
        return {"period": "months", "time": 6};
        break;
      case 9:
        return {"period": "years", "time": 1};
        break;
      default:
        return {"period": "years", "time": 1};
        break;
    }
  }
}
