import 'package:flutter/material.dart';
import 'package:simplybudget/Components/maincard.dart';
import 'package:simplybudget/Components/budgetcard.dart';
import 'package:simplybudget/Components/budgeteditcard.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/config/colors.dart';


class Budgeting extends StatefulWidget {
  @override
  _BudgetingState createState() => _BudgetingState();
}

class _BudgetingState extends State<Budgeting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.BackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 170,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topRight,
                    stops: [0.1, 0.5, 0.8],
                    colors: [
                      MyColors.MainFade2,
                      MyColors.MainFade3,
                      MyColors.MainFade1,
                    ],
                  ),
                ),
                child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Budgeting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    MainCard(
                        onCardPress: () {
                          print("card PRESSEDDDD");
                        },
                        icon: 'assets/images/debit_card.svg',
                        color: MyColors.AccountOneColor,
                        mainText: 'How do you want to budget for the next budgeting period',
                        mainValue: '+\$1,350',
                        mainValueColor: MyColors.GREEN,
                        isButtonVisible: false,
                        isSecondValueVisible: true,
                        secondValue: "\$6,750",
//                        secondValueColor: MyColors.GREEN,
                        onButtonPress: () {}),


                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Set Spending Budget', style: TextStyle(fontSize: 20.0, color: MyColors.TextSecondColor),),

              Container(
                child: Column(
                  children: <Widget>[
                    BudgetEditCard(budgetName: "Bills",),
                    BudgetEditCard(budgetName: "Car",),
                    BudgetEditCard(budgetName: "Eating out",),

                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton(
                color: MyColors.MainFade1,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),

                ),
                child: Text(
                  'Done',
                  style: TextStyle(color: MyColors.WHITE),
                ),
                onPressed: ()  {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
