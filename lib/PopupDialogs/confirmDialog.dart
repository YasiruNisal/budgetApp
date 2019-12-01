import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';


class ConfirmDialog extends StatelessWidget {

  final Function onClickYes;
  final String question;

  ConfirmDialog({this.onClickYes, this.question});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Confirm',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 100.0,
          child: Column(
            children: <Widget>[
              Text(question),
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
                      onClickYes();
                      _dismissDialog(context);
                    },
                    icon:
                    Icon(Icons.check_circle, size: 15.0, color: MyColors.WHITE),
                    label: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: MyColors.WHITE,
                      ),
                    ),
//                            color: MyColors.MainFade2,
                  ),
                  SizedBox(width: 15.0,),
                  FlatButton.icon(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: ()
                    {
                      _dismissDialog(context);
                    },
                    icon:
                    Icon(Icons.cancel, size: 15.0, color: MyColors.WHITE),
                    label: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: MyColors.WHITE,
                      ),
                    ),
//                            color: MyColors.MainFade2,
                  ),
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
