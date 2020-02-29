import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/accountdetailscard.dart';
import 'package:simplybudget/Components/listautopayhome.dart';
import 'package:simplybudget/Components/listbudgetshome.dart';
import 'package:simplybudget/PopupDialogs/createOrEditAutoPay.dart';
import 'package:simplybudget/PopupDialogs/createOrEditBudget.dart';
import 'package:simplybudget/PopupDialogs/selectTansferInOut.dart';
import 'package:simplybudget/PopupDialogs/subscribeDialog.dart';
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

  final _random = new Random();
  int rand = 0;
  int max = 3;
  int min = 0;

  List<String> randMessageArray = [
    'Did you know ?\n\nWithout subscribing you can only keep 4 months worth of account activity history.\n\n'
        'Consider subscribing to get unlimited activity history and more unlimited features',
    'Did you know ?\n\nWithout subscribing you can only create 5 budgets.\n\n'
        'Consider subscribing to get unlimited budgets and more unlimited features',
    'Did you know ?\n\nWithout subscribing you can only create 3 auto payments .\n\n'
        'Consider subscribing to get unlimited auto payments and more unlimited features'
  ];

  static const BUDGETNUM_LIMIT = 4;
  static const AUTOPAYNUM_LIMIT = 3;

  int whichAccount = 0;
  int incomeOrExpense = 0;
  int transferInOut = 0;
  String category = '';
  String displayCategoryName = '';
  double enterValue = 0;

  String normalAccountName = "Spending Account";
  String savingAccountName = "Saving Account";
  double normalAccountBalance = 0;
  double savingAccountBalance = 0;
  int accountCreated = 0;
  String currency = "\$";
  int numBudgets = 0;
  int numAutoPay = 0;

  String localizedPrice = "";
  List<IAPItem> productList;
  List<PurchasedItem> purchasedItems;

  var fireBaseListener;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

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
    rand = (min + _random.nextInt(max - min));
    initPlatformState();
//    _getProduct();
//    _getPurchases();
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print(productItem);
      purchasedItems.add(productItem);
      _acknowledgePurchaseAndroid(productItem.purchaseToken);
      setState(() {
        purchasedItems[0] = productItem;
      });
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: ');
      print(purchaseError);
    });
  }

  Future<void> initPlatformState() async {
    // prepare
    await FlutterInappPurchase.instance.initConnection;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    await _getProduct();
    print("============================================");
//    await _getPurchaseHistory();
    await _getPurchases();
    print("============================================");
  }

  @override
  void dispose() async {
    fireBaseListener?.cancel();
    _purchaseUpdatedSubscription.cancel();
    _purchaseUpdatedSubscription = null;
    _purchaseErrorSubscription.cancel();
    _purchaseErrorSubscription = null;
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }

  Future _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(["ul_16022020"]);

    setState(() {
      localizedPrice = items[0].localizedPrice;
      productList = items;
    });
  }

  Future _getPurchases() async {
    List<PurchasedItem> items = await FlutterInappPurchase.instance.getAvailablePurchases();

    print(items);
    setState(() {
      purchasedItems = items;
    });
  }

  void _purchase() {
    FlutterInappPurchase.instance.requestPurchase("ul_16022020");
  }

  Future _acknowledgePurchaseAndroid(purchaseToken) async {
    String result = await FlutterInappPurchase.instance.acknowledgePurchaseAndroid(purchaseToken);
    print(result);
  }

//  Future _getPurchaseHistory() async {
//    List<PurchasedItem> items = await FlutterInappPurchase.instance.getPurchaseHistory();
//    for (var item in items) {
//      print(item);
//
//    }
//  }

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
              _showUpgradeMessage(),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _showUpgradeMessage() {
    Widget subMessage = Container(
      //SHOW THIS IF ONLY THERE IS ONE BUDGET
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: MyColors.TransparentBack,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.info,
                  color: Colors.black45,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text('Upgrade', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0)),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
                'Subscribe to get unlimited features \n\t- Unlimited Budgets '
                '\n\t- Unlimited Auto Payments \n\t- Unlimited history record of your activities',
                style: TextStyle(
//                        fontFamily: 'Montserrat',
                    color: Colors.black87,
                    fontSize: 15.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(localizedPrice.toString() + "/Month",
                style: TextStyle(
//                        fontFamily: 'Montserrat',
                    color: MyColors.MainFade3,
                    fontSize: 15.0)),
            SizedBox(
              height: 15.0,
            ),
            FlatButton.icon(
              color: MyColors.MainFade2,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              onPressed: () {
                _purchase();
              },
              icon: Icon(Icons.subscriptions, size: 18.0, color: MyColors.WHITE),
              label: Text(
                "Subscribe Now",
                style: TextStyle(
                  fontSize: 15.0,
                  color: MyColors.WHITE,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget noteMessage = Container(
      //SHOW THIS IF ONLY THERE IS ONE BUDGET
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: MyColors.TransparentBack,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.info,
                  color: Colors.black45,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text('Note', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0)),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(randMessageArray[rand],
                style: TextStyle(
//                        fontFamily: 'Montserrat',
                    color: Colors.black87,
                    fontSize: 15.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(localizedPrice.toString() + "/Month",
                style: TextStyle(
//                        fontFamily: 'Montserrat',
                    color: MyColors.MainFade3,
                    fontSize: 15.0)),
            SizedBox(
              height: 15.0,
            ),
            FlatButton.icon(
              color: MyColors.MainFade2,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              onPressed: () {
                _purchase();
              },
              icon: Icon(Icons.subscriptions, size: 18.0, color: MyColors.WHITE),
              label: Text(
                "Subscribe Now",
                style: TextStyle(
                  fontSize: 15.0,
                  color: MyColors.WHITE,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if ((numBudgets > BUDGETNUM_LIMIT || numAutoPay > AUTOPAYNUM_LIMIT) && purchasedItems != null && purchasedItems.length == 0) {
      return subMessage;
    } else {
      return noteMessage;
    }
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
            normalAccountBalance: normalAccountBalance,
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
            normalAccountBalance: normalAccountBalance,
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
    if (numAutoPay > AUTOPAYNUM_LIMIT && purchasedItems != null && purchasedItems.length == 0) {
      //show subscribe popup
      showDialog(
          context: context,
          builder: (context) {
            return SubscribeDialog(
              onClickYes: _purchase,
              monthlyCost: localizedPrice.toString(),
            );
          });
    } else {
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
      name = "New Auto Pay";
    }

    if (repeatPeriod == null) {
      //'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 9;
    }

    try {
      FireStoreService(uid: widget.user.uid).createNewAutoPay(name, autoPayAmount, pickedTime, repeatPeriod, resetDate, numAutoPay);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }
  }

//--------------------------------------------------------//
// Opens the popup dialog for creating the new widget
//--------------------------------------------------------//
  void _createNewBudget() {
    if (numBudgets > BUDGETNUM_LIMIT && purchasedItems != null && purchasedItems.length == 0) {
      //show subscribe popup
      showDialog(
          context: context,
          builder: (context) {
            return SubscribeDialog(
              onClickYes: _purchase,
              monthlyCost: localizedPrice.toString(),
            );
          });
    } else {
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
      name = "New Budget";
    }

    if (repeatPeriod == null) {
      //'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 9;
    }

    try {
      FireStoreService(uid: widget.user.uid).createNewBudget(name, budgetLimit, pickedTime, repeatPeriod, resetDate, numBudgets);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

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
  void _setIncomeCategory(String val, String displayName) {
    setState(() {
      displayCategoryName = displayName;
      category = val;
    });
    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: _enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance, displayName: displayCategoryName,);
        });
  }

//--------------------------------------------------------//
// Select the expense category from the icon popup dialog
//--------------------------------------------------------//
  void _setExpenseCategory(String val, String displayName) {
    setState(() {
      displayCategoryName = displayName;
      category = val;
    });

    showDialog(
        context: context,
        builder: (context) {
          return EnterBudgetValue(enterBudgetValue: _enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance, displayName: displayCategoryName,);
        });
  }

  void _transferToSaving(double amount) {
    try {
      FireStoreService(uid: widget.user.uid).transferToSavingAccount(amount, normalAccountBalance, savingAccountBalance);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

  }

  void _transferOutOfSaving(double amount) {
    try {
      FireStoreService(uid: widget.user.uid).transferOutOfSavingAccount(amount, normalAccountBalance, savingAccountBalance);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

  }

//--------------------------------------------------------//
// Enter a dollar value spent
//--------------------------------------------------------//
  void _enterBudgetValue(double val, String displayName) {
    setState(() {
      enterValue = val;
    });

    dynamic result = FireStoreService(uid: widget.user.uid).setNormalAccountEntry(incomeOrExpense, displayName, new DateTime.now().millisecondsSinceEpoch, enterValue, normalAccountBalance);
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
    try {
      FireStoreService(uid: widget.user.uid).setCurrency(currency);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }
  }

  void _signOut() async {
    await _auth.signOut();
    await _auth.signOutGoogle();
  }
}

//--- product list JSON
//"productId":ul_16022020,
//"price":3.99,
//"currency":"NZD",
//"localizedPrice":$3.99,
//"title":"Unlimited (Simply Budget)",
//"description":"Have access to unlimited features",
//"introductoryPrice":,
//"introductoryPricePaymentModeIOS":,
//"subscriptionPeriodNumberIOS":null,
//"subscriptionPeriodUnitIOS":null,
//"introductoryPricePaymentModeIOS":null,
//"introductoryPriceNumberOfPeriodsIOS":null,
//"introductoryPriceSubscriptionPeriodIOS":null,
//"subscriptionPeriodAndroid":P1M,
//"introductoryPriceCyclesAndroid":,
//"introductoryPricePeriodAndroid":,
//"freeTrialPeriodAndroid":,
//"iconUrl":,
//"originalJson":{
//"skuDetailsToken":"AEuhp4K7eHS-hf7QRDtQ1gJmxZOMk8e0Rfx68u94JL6Um12czEQFAMVTExyeac42Ng5R",
//"productId":"ul_16022020",
//"type":"subs",
//"price":"$3.99",
//"price_amount_micros":3990000,
//"price_currency_code":"NZD",
//"subscriptionPeriod":"P1M",
//"title":"Unlimited (Simply Budget)",
//"description":"Have access to unlimited features"
//},
//"originalPrice":{
//"skuDetailsToken":"AEuhp4K7eHS-hf7QRDtQ1gJmxZOMk8e0Rfx68u94JL6Um12czEQFAMVTExyeac42Ng5R",
//"productId":"ul_16022020",
//"type":"\"subs"

//--purchase item JSON
//"productId":ul_16022020,
//"transactionId":GPA.3374-4044-8375-71759,
//"transactionDate":2020-02-29T00:35:16.264,
//"transactionReceipt":{
//"orderId":"GPA.3374-4044-8375-71759",
//"packageName":"com.yasiru.simplybudget",
//"productId":"ul_16022020",
//"purchaseTime":1582889716264,
//"purchaseState":0,
//"purchaseToken":"bhflgcpojldgindidojhllco.AO-J1OxTN5g6Pr2GBJdqvyLVsgRqRfDV3qBkwQxIfISVGBWuV1GR_3-hMmuxbI9O1nPi63hYTSQ5wzRQJSJDQbK3W14C08eBSzqJ_cKkZGy9bxJ7_9K0eDA4clx6udNrNv49YYTSQ_o3",
//"autoRenewing":true,
//"acknowledged":false
//},
//"purchaseToken":bhflgcpojldgindidojhllco.AO-J1OxTN5g6Pr2GBJdqvyLVsgRqRfDV3qBkwQxIfISVGBWuV1GR_3-hMmuxbI9O1nPi63hYTSQ5wzRQJSJDQbK3W14C08eBSzqJ_cKkZGy9bxJ7_9K0eDA4clx6udNrNv49YYTSQ_o3,
//"orderId":GPA.3374-4044-8375-71759,
//"dataAndroid":null,
//"signatureAndroid":F55MQLpVcl/lDuaZ0pJIqppDlf3aWV1WJjsVWc8yhWfW469lS2tBclwSE0tnHwjx0UsQt9BW1OYzOWlIPag+lt3MpCNiGFVXhrWr5tZFwipkuWrIOqLiiO3UXDlLQliXMQgCvBbQIlyMtpVGauv4cPzTgaC6GgRLlg58cCBGqhTyswttg7OmCt/i7s283ZPNxPdsf1KDrsBkolpntHHlMtdyJUaadt4Uk3HiVZ6v4JW88e3msncg/a4VLSB1gxpXMehjGSo

//---product purchase listener response
//"productId":ul_16022020,
//"transactionId":GPA.3337-3362-7951-37206,
//"transactionDate":2020-02-29T00:41:54.160,
//"transactionReceipt":{
//"orderId":"GPA.3337-3362-7951-37206",
//"packageName":"com.yasiru.simplybudget",
//"productId":"ul_16022020",
//"purchaseTime":1582890114160,
//"purchaseState":0,
//"purchaseToken":"ojkffgjfgfhkcjcgnkicpfcn.AO-J1OzRMU1SX8DYaBvHM8HahRnbUB9UkG1zhbSYzAXANW-3yvdQDR8t80_RSy9dFfJOuGFuxU8sp8Mgny0SidD85yy61odH0NWpCHsuVZ5dBOujSZatenlGOg01bpqiW9KCZDKpiEJj",
//"autoRenewing":true,
//"acknowledged":false
//},
//"purchaseToken":ojkffgjfgfhkcjcgnkicpfcn.AO-J1OzRMU1SX8DYaBvHM8HahRnbUB9UkG1zhbSYzAXANW-3yvdQDR8t80_RSy9dFfJOuGFuxU8sp8Mgny0SidD85yy61odH0NWpCHsuVZ5dBOujSZatenlGOg01bpqiW9KCZDKpiEJj,
//"orderId":GPA.3337-3362-7951-37206,
//"dataAndroid":{
//"orderId":"GPA.3337-3362-7951-37206",
//"packageName":"com.yasiru.simplybudget",
//"productId":"ul_16022020",
//"purchaseTime":1582890114160,
//"purchaseState":0,
//"purchaseToken":"\"ojkffgjfgfhkcjcgnkicpfcn.AO-J1OzRMU1SX8DYaBvHM8HahRnbUB9UkG1zhbSYzAXANW-3yvdQDR8t80_RSy9dFfJOuGFuxU8sp8Mgny0SidD85yy61od"
