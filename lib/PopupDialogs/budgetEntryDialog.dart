import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class BudgetEntryDialog extends StatefulWidget {
  @override
  _BudgetEntryDialogState createState() => _BudgetEntryDialogState();
}

class _BudgetEntryDialogState extends State<BudgetEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Bills - \$350',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 250.0,
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: 'You have spent ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: MyColors.TextMainColor,
                    letterSpacing: 0.8,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\$300',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: MyColors.GREEN,
                          letterSpacing: 0.8,
                        )),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'You have ',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: MyColors.TextMainColor,
                    letterSpacing: 0.8,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\$50',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: MyColors.GREEN,
                          letterSpacing: 0.8,
                        )),
                    TextSpan(
                        text: ' left',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: MyColors.TextMainColor,
                          letterSpacing: 0.8,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                cursorColor: MyColors.MainFade2,
                decoration: InputDecoration(
                  labelText: 'Spending Details',
                  labelStyle: new TextStyle(color: MyColors.MainFade2),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.MainFade2),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
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
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      _dismissDialog(context);
                    },
                    child: Text(
                      'Add',
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
