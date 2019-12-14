import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class TransferToSaving extends StatefulWidget {

  final void Function(double,) transferToSaving;
  final String accountName;

  TransferToSaving({this.transferToSaving, this.accountName,});


  @override
  _TransferToSavingState createState() => _TransferToSavingState();
}

class _TransferToSavingState extends State<TransferToSaving> {

  final enterAmountController = TextEditingController();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    enterAmountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        "Transfer from " + widget.accountName[0].toUpperCase()+ widget.accountName.substring(1),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 160.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: enterAmountController,
                cursorColor: MyColors.MainFade2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Net Balance \$',
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
                      _dismissDialog(context);
                      widget.transferToSaving( double.tryParse(enterAmountController.text),);
                    },
                    child: Text(
                      'Transfer',
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
