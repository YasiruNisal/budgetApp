import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class EnterBudgetValue extends StatefulWidget {

  final void Function(double) enterBudgetValue;
  final int incomeOrExpense;
  final String category;
  final double currentBalance;

  EnterBudgetValue({this.enterBudgetValue, this.incomeOrExpense, this.category, this.currentBalance});

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
    String heading = '';

    if(widget.incomeOrExpense == 1)
      {
        heading = 'income';
      }
    else
      {
       heading = 'expense';
      }

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(

        heading[0].toUpperCase() + heading.substring(1),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 270.0,
          child: Column(
            children: <Widget>[
              Text(
                'Balance \$ ' + widget.currentBalance.toStringAsFixed(2) ,
                style: TextStyle(fontSize: 20.0, letterSpacing: 1.2),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: new BoxDecoration(
                  color: MyColors.TransparentBack,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                height: 40,
                width: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset('assets/${heading}/${widget.category}.png'),
                  ),
                ),
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
                  labelText: '\$ Amount',
                  labelStyle: new TextStyle(color: MyColors.MainFade2),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.MainFade2),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
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
                      print("pressing the button +++++++++++++");
                      _dismissDialog(context);
                      widget.enterBudgetValue( double.tryParse(enterValController.text));
                    },
                    child: Text(
                      'Save',
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
