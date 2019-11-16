import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SelectIncomeExpense extends StatelessWidget {
  final void Function(int) setIncomeExpense;

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
                      _dismissDialog(context);
                      setIncomeExpense(1);
//                      incomeCategory(context);
                    },
                    child: Text(
                      'Income',
                      style: TextStyle(color: MyColors.WHITE),
                    ),
                  ),
                  FlatButton(
                      color: MyColors.MainFade2,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        _dismissDialog(context);
                        setIncomeExpense(2);
                      },
                      child: Text(
                        'Expense',
                        style: TextStyle(color: MyColors.WHITE),
                      )),
//                  FlatButton(
//                      onPressed: () {
//                        DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2018, 3, 5), maxTime: DateTime(2020, 6, 7), onChanged: (date) {
//                          print('change $date');
//                        }, onConfirm: (date) {
//
//                          print('confirm' + (DateTime.parse(date.toString()).millisecondsSinceEpoch).toString());
//                        }, currentTime: DateTime.now(), locale: LocaleType.en);
//                      },
//                      child: Text(
//                        'show date time picker',
//                        style: TextStyle(color: Colors.blue),
//                      ))
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
