import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplybudget/Components/accountdetailscard.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/PopupDialogs/editaccountdetails.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/PopupDialogs/selectExpenseCategory.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeCategory.dart';
import 'package:simplybudget/Screens/Home/budgeting.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:simplybudget/Components/maincard.dart';
import 'package:simplybudget/Components/budgetcard.dart';
import 'package:simplybudget/PopupDialogs/enterBudgetValue.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeExpense.dart';
import 'package:simplybudget/PopupDialogs/budgetEntryDialog.dart';
import 'package:simplybudget/PopupDialogs/signout.dart';

class AccountDetails extends StatefulWidget {
  final FirebaseUser user;

  AccountDetails({this.user});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final AuthService _auth = AuthService();

  int whichAccount = 0;
  String incomeOrExpense = '';
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
    FireStoreService(uid: widget.user.uid)
        .accountData
        .listen((documentSnapshot) {
      print(documentSnapshot.data);
      setState(() {
        normalAccountName = documentSnapshot.data["normalaccountname"];
        savingAccountName = documentSnapshot.data["savingaccountname"];
        normalAccountBalance =
            documentSnapshot.data["normalaccountbalance"].toDouble();
        savingAccountBalance =
            documentSnapshot.data["savingaccountbalance"].toDouble();
        currency = documentSnapshot.data["currency"];
        numBudgets = documentSnapshot.data["numberbudgets"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    final accountDetails = Provider.of<DocumentSnapshot>(context);
//    print(accountDetails.data);

//
//    if(accountDetails.data == null)
    {
//        return Loading();
    }
//    else
    {
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
            height: MediaQuery.of(context).size.height - 140.0,
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
                        height: MediaQuery.of(context).size.height - 475.0,
                        child: ListView(children: [
                          AccountDetailsCard(
                              imgPath: 'assets/images/account.png',
                              balance: normalAccountBalance,
                              accountName: normalAccountName,
                              currency: currency,
                              onPlusClick: () {
                                whichAccount = 1;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SelectIncomeExpense(
                                          setIncomeExpense: setIncomeExpense);
                                    });
                              }),
                          AccountDetailsCard(
                              imgPath: 'assets/images/savingaccount.png',
                              balance: savingAccountBalance,
                              accountName: savingAccountName,
                              currency: currency,
                              onPlusClick: () {
                                whichAccount = 2;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SelectIncomeExpense(
                                          setIncomeExpense: setIncomeExpense);
                                    });
                              }),
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
                DecideBudgetWidget(),
              ],
            ),
          ),
        ],
      ));
    }
  }

  Widget DecideBudgetWidget() {
    if (numBudgets == 0) {
      return FlatButton.icon(
        color: MyColors.MainFade2,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        onPressed: () {},
        icon: Icon(Icons.add, size: 18.0, color: MyColors.WHITE),
        label: Text(
          "Start Creating a Budget",
          style: TextStyle(
            fontSize: 15.0,
            color: MyColors.WHITE,
          ),
        ),
//                            color: MyColors.MainFade2,
      );
    } else {
      return Text("its 9999999999999999");
    }
  }

//--------------------------------------------------------//
// Select income or expense from the popup dialog
//--------------------------------------------------------//
  void setIncomeExpense(String val) {
    setState(() {
      incomeOrExpense = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          if (val == 'expense') {
            return SelectExpenseCategory(
                setExpenseCategory: setExpenseCategory);
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
          return EnterBudgetValue(
              enterBudgetValue: enterBudgetValue,
              incomeOrExpense: incomeOrExpense,
              category: category);
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
          return EnterBudgetValue(
              enterBudgetValue: enterBudgetValue,
              incomeOrExpense: incomeOrExpense,
              category: category);
        });
  }

//--------------------------------------------------------//
// Enter a dollar value spent
//--------------------------------------------------------//
  void enterBudgetValue(double val) {
    setState(() {
      enterValue = val;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Budgeting()),
    );
    // need to write to the database here
  }

  void editAccountDetails(String name, double amount, String type) {
    print(name + "  " + amount.toString() + "  " + type);
  }

  void signOut() async {
    await _auth.signOut();
    await _auth.signOutGoogle();
  }
}
