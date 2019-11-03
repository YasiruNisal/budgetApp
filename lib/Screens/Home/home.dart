import 'package:flutter/material.dart';
import 'package:simplybudget/Components/maincard.dart';
import 'package:simplybudget/Components/budgetcard.dart';
import 'package:simplybudget/Components/budgeteditcard.dart';
import 'package:simplybudget/Screens/Home/budgeting.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/config/colors.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.BackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 310,
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
                      'My Wallet',
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
                        mainText: 'Account Balance',
                        mainValue: '\$6,750',
                        buttonIcon: Icons.edit,
                        buttonText: "Edit",
                        isButtonVisible: true,
                        isSecondValueVisible: false,
                        onButtonPress: () {
                          cashFlowDialog(context);
                        }),
                    MainCard(
                      onCardPress: () {
                        print("card PRESSEDDDD");
                      },
                      icon: 'assets/images/credit_card.svg',
                      color: MyColors.AccountTwoColor,
                      mainText: 'Savings Account Balance',
                      mainValue: '\$12,700',
                      buttonIcon: Icons.edit,
                      buttonText: "Edit",
                      isButtonVisible: true,
                      onButtonPress: () {
                        cashFlowDialog(context);
                      },
                      isSecondValueVisible: false,
                    ),
                    FlatButton.icon(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        await _auth.signOut();
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
                      color: MyColors.MainFade2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Budgets', style: TextStyle(fontSize: 20.0, color: MyColors.TextSecondColor),),

              Container(
                child: Column(
                  children: <Widget>[
                    BudgetCard(
                      budgetName: "Bills",
                      budgetSetValue: "\$350",
                      budgetSpentValue: "\$300",
                      budgetSpentValueColor: MyColors.GREEN,
                      onCardClick: () {budgetEntryDialog(context);},
                    ),
                    BudgetCard(
                      budgetName: "Car",
                      budgetSetValue: "\$120",
                      budgetSpentValue: "\$125",
                      budgetSpentValueColor: MyColors.RED,
                      onCardClick: () {budgetEntryDialog(context);},
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void cashFlowDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              'Cashflow',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 250.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      '\$6,750',
                      style: TextStyle(fontSize: 30.0, letterSpacing: 1.2),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      cursorColor: MyColors.MainFade2,
                      decoration: InputDecoration(
                        labelText: 'Description',
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
                        labelText: '\$',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              'Minus',
                              style: TextStyle(color: MyColors.WHITE),
                            )),
                        FlatButton(
                          color: MyColors.MainFade2,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          onPressed: () {
                            _dismissDialog(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Budgeting()),
                            );
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
        });
  }

  void budgetEntryDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
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
        });
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}
