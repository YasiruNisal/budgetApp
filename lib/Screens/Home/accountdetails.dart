import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplybudget/PopupDialogs/editaccountdetails.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/PopupDialogs/selectExpenseCategory.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeCategory.dart';
import 'package:simplybudget/Screens/Home/budgeting.dart';
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

  String incomeOrExpense = '';
  String category = '';
  double enterValue = 0;



  @override
  Widget build(BuildContext context) {

    final accountdetails = Provider.of<QuerySnapshot>(context);
    print(accountdetails.documents);

    for(var doc in accountdetails.documents){
      print(doc.data);
    }


    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //--------------------------------------------------------------//
          // Start of the purple gradient area
          //--------------------------------------------------------------//
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
//
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SignOutDialog(signOut: signOut);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'My Wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                //--------------------------------------------------------//
                // Start of the Account balance card
                //--------------------------------------------------------//
                MainCard(
                    onCardPress: () {
                      showDialog(context: context,
                      builder: (context){
                        return EditAccountDetails(enterAccountDetails: editAccountDetails, accountName: "New Name", accountAmount: 6580, whichAccount: "normalaccount");
                      });
                    },
                    icon: 'assets/images/debit_card.svg',
                    color: MyColors.AccountOneColor,
                    mainText: 'Account Balance',
                    mainValue: '\$6,750',
                    buttonIcon: Icons.add,
                    isButtonVisible: true,
                    onButtonPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SelectIncomeExpense(
                                setIncomeExpense: setIncomeExpense);
                          });
                    },
                    secondButtonIcon: Icons.arrow_right,
                    isSecondButtonVisible: true,
                    onSecondButtonPress:(){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SelectIncomeExpense(
                                setIncomeExpense: setIncomeExpense);
                          });
                    }
                ),

                //--------------------------------------------------------//
                // End of the Account balance card
                //--------------------------------------------------------//
                //--------------------------------------------------------//
                // Start of the Savings account balance card
                //--------------------------------------------------------//
                MainCard(
                    onCardPress: () {
                      print("card PRESSEDDDD");
                    },
                    icon: 'assets/images/credit_card.svg',
                    color: MyColors.AccountTwoColor,
                    mainText: 'Savings Account Balance',
                    mainValue: '\$12,700',
                    buttonIcon: Icons.add,
                    isButtonVisible: true,
                    onButtonPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SelectIncomeExpense(
                                setIncomeExpense: setIncomeExpense);
                          });
                    },
                    secondButtonIcon: Icons.arrow_right,
                    isSecondButtonVisible: true,
                    onSecondButtonPress:(){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SelectIncomeExpense(
                                setIncomeExpense: setIncomeExpense);
                          });
                    }
                ),
                //--------------------------------------------------------//
                // Start of the Account balance card
                //--------------------------------------------------------//
              ],
            ),
          ),
          //--------------------------------------------------------------//
          // End of the purple gradient area
          //--------------------------------------------------------------//
          SizedBox(
            height: 15,
          ),
          Text(
            'Budgets',
            style:
            TextStyle(fontSize: 20.0, color: MyColors.TextSecondColor),
          ),
          Container(
            child: Column(
              children: <Widget>[
                BudgetCard(
                  budgetName: "Bills",
                  budgetSetValue: "\$350",
                  budgetSpentValue: "\$300",
                  budgetSpentValueColor: MyColors.GREEN,
                  onCardClick: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BudgetEntryDialog();
                        });
                  },
                ),
                BudgetCard(
                  budgetName: "Car",
                  budgetSetValue: "\$120",
                  budgetSpentValue: "\$125",
                  budgetSpentValueColor: MyColors.RED,
                  onCardClick: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BudgetEntryDialog();
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              category:category);
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

  void editAccountDetails(String name, double amount, String type){
    print(name + "  " + amount.toString() + "  " + type);
  }

  void signOut() async {
    await _auth.signOut();
    await _auth.signOutGoogle();
  }
}
