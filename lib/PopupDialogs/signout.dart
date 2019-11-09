import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';


class SignOutDialog extends StatelessWidget {

  final Function signOut;

  SignOutDialog({this.signOut});


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Sign Out',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    color: MyColors.MainFade2,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: ()
                    {
                      signOut();
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
