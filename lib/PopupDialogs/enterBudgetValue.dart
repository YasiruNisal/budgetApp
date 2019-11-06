import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class EnterBudgetValue extends StatefulWidget {

  final void Function(double) enterBudgetValue;
  final String incomeOrExpense;

  EnterBudgetValue({this.enterBudgetValue, this.incomeOrExpense});

  @override
  _EnterBudgetValueState createState() => _EnterBudgetValueState();
}

class _EnterBudgetValueState extends State<EnterBudgetValue> {

  final enterValController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    enterValController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        widget.incomeOrExpense,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 200.0,
          child: Column(
            children: <Widget>[
              Text(
                '\$6,750',
                style: TextStyle(fontSize: 30.0, letterSpacing: 1.2),
              ),
              SizedBox(
                height: 5.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: enterValController,
                cursorColor: MyColors.MainFade2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '\$',
                  labelStyle: new TextStyle(color: MyColors.MainFade2),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.MainFade2),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      _dismissDialog(context);
                      widget.enterBudgetValue( double.tryParse(enterValController.text));
                    },
                    child: Text(
                      'Start Budgeting the income',
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
