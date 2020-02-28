import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';


class SubscribeDialog extends StatelessWidget {

  final Function onClickYes;
  final String monthlyCost;

  SubscribeDialog({this.onClickYes, this.monthlyCost});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Reached free usage limit',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 300.0,
          child: Column(
            children: <Widget>[
              Text('Subscribe to get unlimited features ', style: TextStyle(fontWeight: FontWeight.bold, ),),
              Text('\n\t- Unlimited Budgets '
                  '\n\t- Unlimited Auto Payments \n\t- Unlimited Activity History',),
              SizedBox(
                height: 15.0,
              ),
              Text(monthlyCost + '/Month', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.MainFade3),),
              SizedBox(
                height: 20.0,
              ),
              Column(
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
                      "Subscribe Now",
                      style: TextStyle(
                        fontSize: 16.0,
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
                      "No, Thank you",
                      style: TextStyle(
                        fontSize: 15.0,
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
