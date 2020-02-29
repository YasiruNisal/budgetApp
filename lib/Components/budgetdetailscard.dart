import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';

class BudgetDetailCard extends StatelessWidget {
//  final Function onPlusClick;
  final FirebaseUser user;
  final String id;
  final String currency;
  final double budgetLimit;
  final double budgetSpent;
  final String budgetName;
  final int budgetStartDate;
  final int budgetResetDate;
  final int budgetRepeat;
  final Function(String, double, double) onPlusClick;
  final Function(String, String, double, double, int, int) onCardTap;

//  final String currency;

  BudgetDetailCard({this.user, this.id, this.currency, this.budgetName, this.budgetLimit, this.budgetSpent, this.onPlusClick, this.onCardTap, this.budgetStartDate, this.budgetResetDate, this.budgetRepeat});

  @override
  Widget build(BuildContext context) {
    Color donutColor = MyColors.GREEN;
    double percentage = budgetSpent / budgetLimit;
    if (percentage > 1) {
      percentage = (budgetSpent % budgetLimit) / budgetLimit;
      donutColor = MyColors.RED;
    }

    int today = DateTime.now().millisecondsSinceEpoch;
    int resetDate = budgetResetDate;
    if (resetDate == null) {
      resetDate = today;
    }
    if (today > resetDate) {
      resetBudget();
    }

    return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 15.0),
          child: InkWell(
              onTap: () {
                onCardTap(id, budgetName, budgetLimit, budgetSpent, budgetStartDate, budgetRepeat);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(children: [
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 7.0,
                      percent: percentage,
//                  center: new Text("100%"),
                      progressColor: donutColor,
                    ),
                    SizedBox(width: 20.0),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: 190,
                        child: Text(budgetName[0].toUpperCase() + budgetName.substring(1), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 5.0),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 190,
                        child: Text(currency + budgetSpent.toStringAsFixed(2) + " of " + currency + budgetLimit.toStringAsFixed(2) + " spent", style: TextStyle(fontSize: 15.0, color: Colors.grey)),
                      )
                    ])
                  ])),
                  IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.black,
                      onPressed: () {
                        onPlusClick(id, budgetLimit, budgetSpent);
                      })
                ],
              ))),
    );
  }

  void resetBudget() {
    int today = DateTime.now().millisecondsSinceEpoch;
    Map duration = returnBudgetDuration(budgetRepeat);
    int resetDate = budgetStartDate;

    while (resetDate < today) {
      DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(resetDate).year, DateTime.fromMillisecondsSinceEpoch(resetDate).month, DateTime.fromMillisecondsSinceEpoch(resetDate).day);
      var jiffyTime = Jiffy(dt);

      if (duration["period"] == "days") {
        resetDate = jiffyTime.add(days: duration["time"]).millisecondsSinceEpoch;
      } else if (duration["period"] == "months") {
        resetDate = jiffyTime.add(months: duration["time"],).millisecondsSinceEpoch;
      } else if (duration["period"] == "years") {
        resetDate = jiffyTime.add(years: duration["time"],).millisecondsSinceEpoch;
      }
    }

    try {
      FireStoreService(uid: user.uid).resetBudget(id, resetDate, 0);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }
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
