import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';


class SignOutDialog extends StatefulWidget {

  final Function signOut;
  final String email;
  final Function(String) setCurrency;
  final String currency;

  SignOutDialog({this.signOut, this.email, this.setCurrency, this.currency});

  @override
  _SignOutDialogState createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  String pickedCurrency = "Pick a Currency";

  int pickedCurrencyFromArray = 6;

  @override
  void initState() {
    pickedCurrency = widget.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'User',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              Text(widget.email),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  FlatButton.icon(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: ()
                    {
                      widget.signOut();
                      _dismissDialog(context);
                    },
                    icon:
                    Icon(Icons.person, size: 15.0, color: MyColors.WHITE),
                    label: Text(
                      "Signout",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: MyColors.WHITE,
                      ),
                    ),
//                            color: MyColors.MainFade2,
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              DropdownButton<String>(
                hint: Text(pickedCurrency),
                items: repeatPeriods.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      style: TextStyle(color: MyColors.MainFade1),
                    ),
                  );
                }).toList(),
                onChanged: (selected) {
                  setState(() {
                    pickedCurrency = selected;
                  });

                    widget.setCurrency(selected);

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  var repeatPeriods = <String>['£', '\$', '€', '₹', '¥', '₩', '₨', ];

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}
