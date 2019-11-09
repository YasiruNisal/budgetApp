import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class EnterBudgetValue extends StatefulWidget {

  final void Function(double) enterBudgetValue;
  final String incomeOrExpense;
  final String category;

  EnterBudgetValue({this.enterBudgetValue, this.incomeOrExpense, this.category});

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
        widget.incomeOrExpense[0].toUpperCase() + widget.incomeOrExpense.substring(1),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 250.0,
          child: Column(
            children: <Widget>[
              Text(
                'Balance \$6,750',
                style: TextStyle(fontSize: 20.0, letterSpacing: 1.2),
              ),
              SizedBox(
                height: 10.0,
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/${widget.incomeOrExpense}/${widget.category}.png'),
                radius: 20.0,
                backgroundColor: MyColors.TransparentBack,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(widget.category[0].toUpperCase() + widget.category.substring(1), textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: enterValController,
                cursorColor: MyColors.MainFade2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '\$ amount',
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
