import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class BudgetEditCard extends StatelessWidget {
  final String budgetName;
  final String budgetSetValue;
  final String budgetSpentValue;
  final Color budgetSpentValueColor;
  final Function onCardClick;

  BudgetEditCard({
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
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'For ' + budgetName,
                        style: TextStyle(
                          color: MyColors.TextMainColor,
                          fontSize: 20.0,
                          letterSpacing: 1.5,
                        ),
                      ))),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        cursorColor: MyColors.MainFade2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '\$',
                          labelStyle: new TextStyle(color: MyColors.MainFade2),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyColors.MainFade2),
                          ),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
