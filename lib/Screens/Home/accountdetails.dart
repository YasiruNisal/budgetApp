import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/accountdetailscard.dart';
import 'package:simplybudget/Components/listautopayhome.dart';
import 'package:simplybudget/Components/listbudgetshome.dart';
import 'package:simplybudget/PopupDialogs/createOrEditAutoPay.dart';
import 'package:simplybudget/PopupDialogs/createOrEditBudget.dart';
import 'package:simplybudget/PopupDialogs/selectTansferInOut.dart';
import 'package:simplybudget/PopupDialogs/transferOutOfSaving.dart';
import 'package:simplybudget/PopupDialogs/transferToSaving.dart';
import 'package:simplybudget/Screens/Home/savingsdetails.dart';
import 'package:simplybudget/Screens/Home/walletdetails.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/PopupDialogs/selectExpenseCategory.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeCategory.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:simplybudget/PopupDialogs/enterBudgetValue.dart';
import 'package:simplybudget/PopupDialogs/selectIncomeExpense.dart';
import 'package:simplybudget/PopupDialogs/signout.dart';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

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
  int transferInOut = 0;
  String category = '';
  double enterValue = 0;

  String normalAccountName = "Spending Account";
  String savingAccountName = "Saving Account";
  double normalAccountBalance = 0;
  double savingAccountBalance = 0;
  int accountCreated = 0;
  String currency = "\$";
  int numBudgets = 0;
  int numAutoPay = 0;

  var fireBaseListener;

  @override
  void initState() {
    super.initState();
    fireBaseListener = FireStoreService(uid: widget.user.uid).accountData.listen((documentSnapshot) {
      setState(() {
        normalAccountName = documentSnapshot.data["normalaccountname"];
        savingAccountName = documentSnapshot.data["savingaccountname"];
        normalAccountBalance = documentSnapshot.data["normalaccountbalance"].toDouble();
        savingAccountBalance = documentSnapshot.data["savingaccountbalance"].toDouble();
        currency = documentSnapshot.data["currency"];
        numBudgets = documentSnapshot.data["numberbudgets"];
        numAutoPay = documentSnapshot.data["numberautopay"];
        accountCreated = documentSnapshot.data["accountcreated"];
      });
    });
    asyncInitState();
    _getProduct();
  }

  void asyncInitState() async {
    await FlutterInappPurchase.instance.initConnection;
  }

  @override
  void dispose() async {
    fireBaseListener?.cancel();
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }

  Future _getProduct() async {
    print("*******************************");
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(["ul_16022020"]);
    print("________________________________________ ");
    print(items);
    for (var i = 0; i < items.length; ++i) {
      print(items[i].title + " " + items[i].price);
    }
    print("________________________________________");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings_applications),
                color: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SignOutDialog(
                          signOut: _signOut,
                          email: widget.user.email,
                          setCurrency: _pickCurrency,
                          currency: currency,
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
                        onTap: _normalAccountOnClick,
                        onPlusClick: () {
                          setState(() {
                            whichAccount = 0;
                          });
                          if (normalAccountBalance == 0) {
                            _normalAccountOnClick();
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SelectIncomeExpense(setIncomeExpense: _setIncomeExpense);
                                });
                          }
                        }),
                    AccountDetailsCard(
                        imgPath: 'assets/images/savingaccount.png',
                        balance: savingAccountBalance,
                        accountName: savingAccountName,
                        currency: currency,
                        onTap: _savingsAccountOnClick,
                        onPlusClick: () {
                          setState(() {
                            whichAccount = 1;
                          });

                          showDialog(
                              context: context,
                              builder: (context) {
                                return SelectTransferInOut(
                                  setTransferInOut: _setTransferInOut,
                                  savingAccountName: savingAccountName,
                                );
                              });
                        }),
                    SizedBox(
                      height: 45.0,
                    ),
                  ]))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('My',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          color: MyColors.MainFade1,
                          fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text('Budgets',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: MyColors.MainFade1,
                          fontSize: 20.0))
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              _decideBudgetWidget(_createNewBudget),
              SizedBox(
                height: 45.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Auto',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          color: MyColors.MainFade1,
                          fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text('Payments',
                      style: TextStyle(
//                        fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: MyColors.MainFade1,
                          fontSize: 20.0))
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              _decideAutoPaymentWidget(),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ],
    ));
  }

  //--------------------------------------------------------//
// display budget details list on home screen
//--------------------------------------------------------//
  Widget _decideBudgetWidget(Function createNewBudget) {
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
            currency: currency,
            numBudgets: numBudgets,
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

  //--------------------------------------------------------//
  // Displays automatic payments on home screen
  //--------------------------------------------------------//
  Widget _decideAutoPaymentWidget() {
    if (numAutoPay == 0) {
      return FlatButton.icon(
        color: MyColors.MainFade2,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        onPressed: () {
          _createNewAutoPay();
        },
        icon: Icon(Icons.add, size: 18.0, color: MyColors.WHITE),
        label: Text(
          "Start Creating your First Auto Payment",
          style: TextStyle(
            fontSize: 15.0,
            color: MyColors.WHITE,
          ),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          ListAutoPayHomeScreen(
            user: widget.user,
            currency: currency,
            numAutoPay: numAutoPay,
              normalAccountBalance:normalAccountBalance,
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
              _createNewAutoPay();
            },
            icon: Icon(Icons.add, size: 18.0, color: MyColors.WHITE),
            label: Text(
              "Create Auto Payment",
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

  //--------------------------------------------------------//
  // Opens the popup dialog for creating the new auto payment
  //--------------------------------------------------------//
  void _createNewAutoPay() {
    showDialog(
        context: context,
        builder: (context) {
          return CreateOrEditAutoPay(
            newAutoPaySet: _saveNewAutoPay,
            newOrEdit: "New Auto Payment",
            createOrSave: "Create",
          );
        });
  }

  //--------------------------------------------------------//
// Saves the newly created auto pay on the database
//  TODO Do some error checking with the result
//--------------------------------------------------------//
  void _saveNewAutoPay(String autoPayName, double amount, DateTime unixTime, int repeatPeriod, int resetDate) {
    DateTime startDate = unixTime;
    if (unixTime == null) {
      startDate = DateTime.now();
    }

    int pickedTime = startDate.millisecondsSinceEpoch;

    double autoPayAmount = amount;
    if (amount == null) {
      autoPayAmount = 0;
    }

    String name = autoPayName;
    if (autoPayName == null || autoPayName.length == 0) {
      name = "My Budget";
    }

    if (repeatPeriod == null) {
      //'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 9;
    }

    dynamic result = FireStoreService(uid: widget.user.uid).createNewAutoPay(name, autoPayAmount, pickedTime, repeatPeriod, resetDate, numBudgets);
  }

//--------------------------------------------------------//
// Opens the popup dialog for creating the new widget
//--------------------------------------------------------//
  void _createNewBudget() {
    showDialog(
        context: context,
        builder: (context) {
          return CreateOrEditBudget(
            newBudgetSet: _saveNewBudget,
            newOrEdit: "New Budget",
            createOrSave: "Create",
          );
        });
  }

//--------------------------------------------------------//
// Saves the newly created budget on the database
//  TODO Do some error checking with the result
//--------------------------------------------------------//
  void _saveNewBudget(String budgetName, double maxLimit, DateTime unixTime, int repeatPeriod, int resetDate) {
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
      name = "Auto Pay";
    }

    if (repeatPeriod == null) {
      //'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 9;
    }

    dynamic result = FireStoreService(uid: widget.user.uid).createNewBudget(name, budgetLimit, pickedTime, repeatPeriod, resetDate, numAutoPay);
  }

//--------------------------------------------------------//
// Navigates to WalletDetailsPage when Normal account is clicked
//--------------------------------------------------------//
  void _normalAccountOnClick() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WalletDetails(
              user: widget.user,
              selectAccountName: normalAccountName,
              selectAccountValue: normalAccountBalance,
              accountCreated: accountCreated,
              currency: currency,
            )));
  }

  //--------------------------------------------------------//
// Navigates to WalletDetailsPage when Normal account is clicked
//--------------------------------------------------------//
  void _savingsAccountOnClick() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SavingsDetails(
              user: widget.user,
              selectAccountName: savingAccountName,
              selectAccountValue: savingAccountBalance,
              accountCreated: accountCreated,
              currency: currency,
            )));
  }

//--------------------------------------------------------//
// Select income or expense from the popup dialog
//--------------------------------------------------------//
  void _setIncomeExpense(int val) {
    setState(() {
      incomeOrExpense = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          if (val == 2) {
            return SelectExpenseCategory(setExpenseCategory: _setExpenseCategory);
          } else {
            return SelectIncomeCategory(setIncomeCategory: _setIncomeCategory);
          }
        });
  }

  void _setTransferInOut(int val) {
    setState(() {
      transferInOut = val;
    });

    showDialog(
        context: context,
        builder: (context) {
          if (val == 2) {
            //out of
            return TransferOutOfSaving(
              accountName: savingAccountName,
              transferOutOfSaving: _transferOutOfSaving,
            );
          } else {
            //into
            return TransferToSaving(accountName: savingAccountName, transferToSaving: _transferToSaving);
          }
        });
  }

//--------------------------------------------------------//
// Select the income category from the icon popup dialog
//--------------------------------------------------------//
  void _setIncomeCategory(String val) {
    setState(() {
      category = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: _enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance);
        });
  }

//--------------------------------------------------------//
// Select the expense category from the icon popup dialog
//--------------------------------------------------------//
  void _setExpenseCategory(String val) {
    setState(() {
      category = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: _enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance);
        });
  }

  void _transferToSaving(double amount) {
    dynamic result = FireStoreService(uid: widget.user.uid).transferToSavingAccount(amount, normalAccountBalance, savingAccountBalance);
  }

  void _transferOutOfSaving(double amount) {
    dynamic result = FireStoreService(uid: widget.user.uid).transferOutOfSavingAccount(amount, normalAccountBalance, savingAccountBalance);
  }

//--------------------------------------------------------//
// Enter a dollar value spent
//--------------------------------------------------------//
  void _enterBudgetValue(double val) {
    setState(() {
      enterValue = val;
    });

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

  void _pickCurrency(String currency) {
    dynamic result = FireStoreService(uid: widget.user.uid).setCurrency(currency);
  }

  void _signOut() async {
    await _auth.signOut();
    await _auth.signOutGoogle();
  }
}
