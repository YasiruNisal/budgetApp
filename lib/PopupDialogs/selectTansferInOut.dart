import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';


class SelectTransferInOut extends StatelessWidget {
  final void Function(int) setTransferInOut;
  final String savingAccountName;

  SelectTransferInOut({this.setTransferInOut, this.savingAccountName});

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
          height: 150.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      _dismissDialog(context);
                      setTransferInOut(1);
//                      incomeCategory(context);
                    },
                    child: Text(
                      'Into ' + savingAccountName,
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
                        setTransferInOut(2);
                      },
                      child: Text(
                        'Out of ' + savingAccountName,
                        style: TextStyle(color: MyColors.WHITE),
                      )),

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
