import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class EditAccountDetails extends StatefulWidget {

  final void Function(String, double, String) enterAccountDetails;
  final String accountName;
  final double accountAmount;
  final String whichAccount;

  EditAccountDetails({this.enterAccountDetails, this.accountName, this.accountAmount, this.whichAccount});


  @override
  _EditAccountDetailsState createState() => _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails> {

  final enterNameController = TextEditingController();
  final enterAmountController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    enterNameController.dispose();
    enterAmountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        "Edit Account",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 250.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: enterNameController,
                cursorColor: MyColors.MainFade2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  hintText: widget.accountName,
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
                controller: enterAmountController,
                cursorColor: MyColors.MainFade2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '\$ Amount',
                  hintText: widget.accountAmount.toString(),
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
                      widget.enterAccountDetails( enterNameController.text, double.tryParse(enterAmountController.text), widget.whichAccount);
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
