import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class SelectIncomeExpense extends StatelessWidget {

  final void Function(String) setIncomeExpense;

  SelectIncomeExpense({this.setIncomeExpense});



  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Cashflow',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 100.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      color: MyColors.MainFade2,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
//                        setState(() {
//                          incomeOrExpense = 'Expense';
//                        });
                        setIncomeExpense('Expense');
                        _dismissDialog(context);
                      },
                      child: Text(
                        'Expense',
                        style: TextStyle(color: MyColors.WHITE),
                      )),
                  FlatButton(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      _dismissDialog(context);
                      setIncomeExpense('Income');
//                      incomeCategory(context);
                    },
                    child: Text(
                      'Income',
                      style: TextStyle(color: MyColors.WHITE),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}



