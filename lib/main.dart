import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:simplybudget/Components/maincard.dart';
import 'package:simplybudget/Components/budgetcard.dart';
import 'package:simplybudget/Components/budgeteditcard.dart';

import 'package:flutter/cupertino.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
          fontFamily: 'San',
          primaryColor: MyColors.MainFade2,
          accentColor: MyColors.MainFade1,
          secondaryHeaderColor: MyColors.MainFade1),
      home: MainScreen(),
    ));

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.BackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 270,
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
                        secondValue: "+\$1,350",
                        onButtonPress: () {}),
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
                        isButtonVisible: false,
                        secondValue: "+\$1,350",
                        secondValueColor: MyColors.GREEN),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  budgetingPeriodDialog(context);
                },
                child: Text('Show Cupertino Dialog'),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    BudgetCard(
                      budgetName: "Bills",
                      budgetSetValue: "\$350",
                      budgetSpentValue: "\$300",
                      budgetSpentValueColor: MyColors.GREEN,
                    ),
                    BudgetCard(
                      budgetName: "Car",
                      budgetSetValue: "\$120",
                      budgetSpentValue: "\$125",
                      budgetSpentValueColor: MyColors.RED,
                    ),
                    BudgetEditCard(),
                    BudgetEditCard(),
                    BudgetEditCard(),
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

  void newBudgetDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              'New Budget',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 200.0,
                child: Column(
                  children: <Widget>[
                    TextField(
                      cursorColor: MyColors.MainFade2,
                      decoration: InputDecoration(
                        labelText: 'Budget Name',
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
                        labelText: '\$ Set Budget Amount',
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
                            'Done',
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

  void budgetingPeriodDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          final format = DateFormat("yyyy-MM-dd");
          int selectitem = 1;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              'Budgeting Period',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 240.0,
                child: Column(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Text(
                        'Pick Start Date',
                        style: TextStyle(color: MyColors.MainFade2),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor:
                              MyColors.MainFade2, //color of the main banner
                          accentColor: MyColors
                              .MainFade2, //color of circle indicating the selected date
                          buttonTheme: ButtonThemeData(
                              buttonColor: MyColors.MainFade2,
                              textTheme: ButtonTextTheme
                                  .accent //color of the text in the button "OK/CANCEL"
                              ),
                        ),
                        child: DateTimeField(
                          format: format,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Pick Start date',
                      style: TextStyle(color: MyColors.MainFade2),
                    ),
                    Center(
                      child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                            child: Text('Item 1'),
                            value: 'one',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('Item 2'),
                            value: 'two',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('Item 3'),
                            value: 'three',
                          ),
                        ],
                        onChanged: (String value) {
//                          setState(() {
//                            _value = value;
//                          });
                        },
                        hint: Text('Select Item'),
//                        value: _value,
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
                            'Done',
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
