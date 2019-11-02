import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class BudgetCard extends StatelessWidget {
  final String budgetName;
  final String budgetSetValue;
  final String budgetSpentValue;
  final Color budgetSpentValueColor;
  final Function onCardClick;

  BudgetCard({
    this.budgetName,
    this.budgetSetValue,
    this.budgetSpentValue,
    this.budgetSpentValueColor,
    this.onCardClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardClick,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0,18.0,10.0,18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: Alignment.topLeft, child: Text(budgetName, style: TextStyle(color: MyColors.TextMainColor, fontSize: 20.0, letterSpacing: 1.5,),))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center, child: Text(budgetSetValue, style: TextStyle(color: MyColors.NumberMainColor, fontSize: 20.0, letterSpacing: 1.5),))),
              Expanded(
                  child: Align(
                      alignment: Alignment.topRight, child: Text(budgetSpentValue, style: TextStyle(color: budgetSpentValueColor, fontSize: 20.0, letterSpacing: 1.5),))),
            ],
          ),
        ),
      ),
    );
  }
}
