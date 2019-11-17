import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/config/colors.dart';

class BudgetDetailCard extends StatelessWidget {
//  final Function onPlusClick;
  final double budgetLimit;
  final double budgetSpent;
  final String budgetName;
  final Function(String, double, double) onPlusClick;
  final Function(String, double, double) onCardTap;

//  final String currency;

  BudgetDetailCard({this.budgetName, this.budgetLimit, this.budgetSpent, this.onPlusClick, this.onCardTap});


  @override
  Widget build(BuildContext context) {

    Color donutColor = MyColors.GREEN;
    double percentage = budgetSpent/budgetLimit;
    if(percentage > 1){
      percentage = (budgetSpent%budgetLimit)/ budgetLimit;
      donutColor = MyColors.RED;
    }
    return GestureDetector(
      onTap: (){},
      child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 15.0),
          child: InkWell(
              onTap: () {
                onCardTap(budgetName.toLowerCase(), budgetLimit, budgetSpent);
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
                            child: Text(budgetName[0].toUpperCase()+budgetName.substring(1),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            alignment: Alignment.topLeft,
                            width: 190,
                            child: Text(budgetSpent.toStringAsFixed(2) + " of " + budgetLimit.toStringAsFixed(2) + " spent",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey)),
                          )
                        ])
                      ])),
                  IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.black,
                      onPressed: () {
                        onPlusClick(budgetName.toLowerCase(), budgetLimit, budgetSpent);
                      })
                ],
              ))),
    );
  }
}
