import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/accountdetailscard.dart';
import 'package:simplybudget/Components/listbudgetshome.dart';
import 'package:simplybudget/PopupDialogs/createNewBudget.dart';
import 'package:simplybudget/Screens/Home/walletdetails.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/PopupDialogs/selectExpenseCategory.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeCategory.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:simplybudget/PopupDialogs/enterBudgetValue.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeExpense.dart';
import 'package:simplybudget/PopupDialogs/signout.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountDetails extends StatefulWidget {
  final FirebaseUser user;

  AccountDetails({this.user});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final AuthService _auth = AuthService();

  int whichAccount = 0;
  int incomeOrExpense = 0;
  String category = '';
  double enterValue = 0;

  String normalAccountName = "Spending Account";
  String savingAccountName = "Saving Account";
  double normalAccountBalance = 0;
  double savingAccountBalance = 0;
  String currency = "\$";
  int numBudgets = 0;

  @override
  void initState() {
    super.initState();
    FireStoreService(uid: widget.user.uid).accountData.listen((documentSnapshot) {
      setState(() {
        normalAccountName = documentSnapshot.data["normalaccountname"];
        savingAccountName = documentSnapshot.data["savingaccountname"];
        normalAccountBalance = documentSnapshot.data["normalaccountbalance"].toDouble();
        savingAccountBalance = documentSnapshot.data["savingaccountbalance"].toDouble();
        currency = documentSnapshot.data["currency"];
        numBudgets = documentSnapshot.data["numberbudgets"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    final accountDetails = Provider.of<DocumentSnapshot>(context);
//    print(accountDetails.data);

    print(whichAccount.toString() + " " + incomeOrExpense.toString() + " " + category + " " + enterValue.toString());

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SignOutDialog(
                          signOut: signOut,
                          email: widget.user.email,
                        );
                      });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: <Widget>[
              Text('My',
                  style: TextStyle(
//                        fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 25.0)),
              SizedBox(width: 10.0),
              Text('Wallet',
                  style: TextStyle(
//                        fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25.0))
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
//          height: MediaQuery.of(context).size.height + 5*numBudgets,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75.0),
            ),
          ),
          child: Column(

            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Container(
//                      height: ScreenUtil().setHeight(400),//MediaQuery.of(context).size.height -
                      child: Column(children: [
                          AccountDetailsCard(
                            imgPath: 'assets/images/account.png',
                            balance: normalAccountBalance,
                            accountName: normalAccountName,
                            currency: currency,
                              onTap : normalAccountOnClick,
                            onPlusClick: () {
                              setState(() {
                                whichAccount = 1;
                              });

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectIncomeExpense(setIncomeExpense: setIncomeExpense);
                                  });
                            }),
                        AccountDetailsCard(
                            imgPath: 'assets/images/savingaccount.png',
                            balance: savingAccountBalance,
                            accountName: savingAccountName,
                            currency: currency,
                            onPlusClick: () {
                              setState(() {
                                whichAccount = 2;
                              });

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectIncomeExpense(setIncomeExpense: setIncomeExpense);
                                  });
                            }),

                        SizedBox(height: 45.0,),
                      ]))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('My',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          color: MyColors.TextSecondColor,
                          fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text('Budgets',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: MyColors.TextSecondColor,
                          fontSize: 20.0))
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              decideBudgetWidget(createNewBudget),
              SizedBox(height: 20.0,)

            ],
          ),
        ),
      ],
    ));
  }

  Widget decideBudgetWidget(Function createNewBudget) {
    if (numBudgets == 0) {
      return FlatButton.icon(
        color: MyColors.MainFade2,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        onPressed: () {
          createNewBudget();
        },
        icon: Icon(Icons.add, size: 18.0, color: MyColors.WHITE),
        label: Text(
          "Start Creating your First Budget",
          style: TextStyle(
            fontSize: 15.0,
            color: MyColors.WHITE,
          ),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          ListBudgetsHomeScreen(
            user: widget.user,
          ),

          SizedBox(
            height: 20.0,
          ),
          FlatButton.icon(
            color: MyColors.MainFade2,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: () {
              createNewBudget();
            },
            icon: Icon(Icons.add, size: 18.0, color: MyColors.WHITE),
            label: Text(
              "Start Creating a Budget",
              style: TextStyle(
                fontSize: 15.0,
                color: MyColors.WHITE,
              ),
            ),
          )
        ],
      );
    }
  }

  void createNewBudget() {
    showDialog(
        context: context,
        builder: (context) {
          return CreateNewBudget(newBudgetSet: saveNewBudget);
        });
  }

  void saveNewBudget(String budgetName, double maxLimit, DateTime unixTime, int repeatPeriod) {
    DateTime startDate = unixTime;
    if (unixTime == null) {
      startDate = DateTime.now();
    }

    int pickedTime = startDate.millisecondsSinceEpoch;

    double budgetLimit = maxLimit;
    if (maxLimit == null) {
      budgetLimit = 0;
    }

    String name = budgetName;
    if (budgetName == null || budgetName.length == 0) {
      name = "My Budget";
    }

    if(repeatPeriod == null){//'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 10;
    }

    dynamic result = FireStoreService(uid: widget.user.uid).createNewBudget(name, budgetLimit, pickedTime, repeatPeriod, numBudgets);
  }


  void normalAccountOnClick()
  {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WalletDetails(user: widget.user, selectAccountName: normalAccountName, selectAccountValue: normalAccountBalance)
    ));
  }

//--------------------------------------------------------//
// Select income or expense from the popup dialog
//--------------------------------------------------------//
  void setIncomeExpense(int val) {
    setState(() {
      incomeOrExpense = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          if (val == 2) {
            return SelectExpenseCategory(setExpenseCategory: setExpenseCategory);
          } else {
            return SelectIncomeCategory(setIncomeCategory: setIncomeCategory);
          }
        });
  }

//--------------------------------------------------------//
// Select the income category from the icon popup dialog
//--------------------------------------------------------//
  void setIncomeCategory(String val) {
    setState(() {
      category = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance);
        });
  }

//--------------------------------------------------------//
// Select the expense category from the icon popup dialog
//--------------------------------------------------------//
  void setExpenseCategory(String val) {
    setState(() {
      category = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance);
        });
  }

//--------------------------------------------------------//
// Enter a dollar value spent
//--------------------------------------------------------//
  void enterBudgetValue(double val) {
    setState(() {
      enterValue = val;
    });
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Budgeting()),
//    );

    print(normalAccountBalance);
    dynamic result = FireStoreService(uid: widget.user.uid).setNormalAccountEntry(incomeOrExpense, category, new DateTime.now().millisecondsSinceEpoch, enterValue, normalAccountBalance);
    // need to write to the database here.
    if (result != null) {
      setState(() {
        whichAccount = 0;
        incomeOrExpense = 0;
        enterValue = 0;
        category = '';
      });
    }
  }

  void editAccountDetails(String name, double amount, String type) {
    print(name + "  " + amount.toString() + "  " + type);
  }

  void signOut() async {
    await _auth.signOut();
    await _auth.signOutGoogle();
  }
}
