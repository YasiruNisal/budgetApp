import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetDetails extends StatefulWidget {
  final FirebaseUser user;
  final String selectedBudget;
  final double selectedBudgetLimit;
  final double selectedBudgetSpent;

  BudgetDetails({this.user, this.selectedBudget, this.selectedBudgetLimit, this.selectedBudgetSpent});

  @override
  _BudgetDetailsState createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  List<DocumentSnapshot> budgetHistoryList;

  @override
  void initState() {
    super.initState();
//    FireStoreService(uid: widget.user.uid).budgetList.listen((querySnapshot) {
//      setState(() {
//        budgetList = querySnapshot.documents;
//      });
//    });
    FireStoreService(uid: widget.user.uid).budgetHistoryList(widget.selectedBudget.toLowerCase()).listen((querySnapshot) {
      setState(() {
        budgetHistoryList = querySnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color donutColor = MyColors.GREEN;
    double percentage = widget.selectedBudgetSpent / widget.selectedBudgetLimit;
    if (percentage > 1) {
      percentage = (widget.selectedBudgetSpent % widget.selectedBudgetLimit) / widget.selectedBudgetLimit;
      donutColor = MyColors.RED;
    }

    return Scaffold(
        backgroundColor: Color(0xFF7A9BEE),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(widget.selectedBudget[0].toUpperCase() + widget.selectedBudget.substring(1), style: TextStyle(fontSize: 25.0, color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: ListView(children: [
          Stack(children: [
            Container(height: MediaQuery.of(context).size.height + (9*30), width: MediaQuery.of(context).size.width, color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height + 200,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: 'donut pie chart',
                    child: Container(
                        child: CircularPercentIndicator(
                          radius: 170.0,
                          lineWidth: 30.0,
                          percent: percentage,
                          center: new Text(
                            (percentage * 100).toStringAsFixed(1) + " %",
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          progressColor: donutColor,
                        ),
                        height: 200.0,
                        width: 200.0))),
            Positioned(
              top: 250.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Budget Info",
                      style: TextStyle(
                        fontSize: 22.0,
                      )),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text("\$ " + widget.selectedBudgetLimit.toStringAsFixed(2) + " Limit", style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                        ),
                      ),
                      Container(height: 25.0, color: Colors.grey, width: 1.0),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text("\$ " + widget.selectedBudgetSpent.toStringAsFixed(2) + " Spent", style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Budget',
                          style: TextStyle(
//                        fontFamily: 'Montserrat',
                              color: MyColors.TextMainColor,
                              fontSize: 20.0)),
                      SizedBox(width: 5.0),
                      Text('Spendings',
                          style: TextStyle(
//                        fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: MyColors.TextMainColor,
                              fontSize: 20.0))
                    ],
                  ),
                  SizedBox(height: 20.0),
                  checkIfEmpty(),
                ],
              ),
            ),
          ]),
        ]));
  }

  Widget checkIfEmpty() {

    if(budgetHistoryList == null){
      return Loading(size:20.0);
    }
    else{
      if (budgetHistoryList.length == 0) {
        return Text("Seems to be empty", textAlign: TextAlign.center,);
      } else {
        return (
            Flex(direction: Axis.vertical, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  height: budgetHistoryList.length*40.toDouble(),
                  child: SideHeaderListView(
                    itemCount: budgetHistoryList.length,
                    padding: new EdgeInsets.all(10.0),
                    itemExtend: 55.0,
                    headerBuilder: (BuildContext context, int index) {
                      return new SizedBox(
                          width: 50.0,
                          child: dayFromUnix(budgetHistoryList[index].data["timestamp"]
//                        style: Theme.of(context).textTheme.headline,
                          ));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return budgetDetails(budgetHistoryList[index].data["expensecategory"], budgetHistoryList[index].data["amount"]);
                    },
                    hasSameHeader: (int a, int b) {
//                          return names[a].substring(0, 1) == names[b].substring(0, 1);
                      return DateTime.fromMillisecondsSinceEpoch(budgetHistoryList[a].data["timestamp"]).day.toString() ==
                          DateTime.fromMillisecondsSinceEpoch(budgetHistoryList[b].data["timestamp"]).day.toString();
                    },
                  ),
                ),
              ),
            ]));

      }
    }

  }

  Widget budgetDetails(String budgetName, double budgetSpent){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

            Container( alignment: Alignment.topLeft,
                width: 140,child: Text(budgetName[0].toUpperCase()+budgetName.substring(1), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)),
            Container( alignment: Alignment.topLeft,
                width: 100,child: Text("\$ " + budgetSpent.toStringAsFixed(2), style: TextStyle(fontSize: 18.0, color: MyColors.TextSecondColor),)),

      ],
    );
  }

  Widget dayFromUnix(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    print(date.month.toString());
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            date.day.toString(),
            style: TextStyle(fontSize: 25.0),
          ),
          RotatedBox(quarterTurns: 3, child: Text(getMonthString(date.month)))
        ],
      ),
    );
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return '';
        break;
    }
  }
}
