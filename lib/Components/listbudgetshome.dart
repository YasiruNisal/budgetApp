import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/budgetdetailscard.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/PopupDialogs/enterBudgetValue.dart';
import 'package:simplybudget/PopupDialogs/selectExpenseCategory.dart';
import 'package:simplybudget/Screens/Home/budgetdetails.dart';
import 'package:simplybudget/Services/firestore.dart';

class ListBudgetsHomeScreen extends StatefulWidget {
  final FirebaseUser user;
  final String currency;
  final int numBudgets;
  final double normalAccountBalance;

  ListBudgetsHomeScreen({this.user, this.currency, this.numBudgets, this.normalAccountBalance});

  @override
  _ListBudgetsHomeScreenState createState() => _ListBudgetsHomeScreenState();
}

class _ListBudgetsHomeScreenState extends State<ListBudgetsHomeScreen> {
  List<DocumentSnapshot> budgetList;

  String selectedBudgetID = "";
  String selectedBudgetName = "";
  double selectedBudgetLimit = 0;
  double selectedBudgetSpent = 0;
  String category = "";
  double enterValue = 0;

  var fireBaseListener;

  @override
  void initState() {
    super.initState();
    fireBaseListener = FireStoreService(uid: widget.user.uid).budgetList.listen((querySnapshot) {
      setState(() {
        budgetList = querySnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    fireBaseListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (budgetList == null) {
      return Loading(size: 20.0);
    } else {
      return getBudgetListWidget(budgetList);
    }
  }

  Widget getBudgetListWidget(List<DocumentSnapshot> budgets) {
    return Column(
        children: budgets
            .map((item) => BudgetDetailCard(
                  user: widget.user,
                  id: item.documentID,
                  currency: widget.currency,
                  budgetName: item.data["budgetname"],
                  budgetLimit: item.data["budgetlimit"].toDouble(),
                  budgetSpent: item.data["budgetspent"].toDouble(),
                  budgetStartDate: item.data["budgetstartdate"],
                  budgetResetDate: item.data["budgetresetdate"],
                  budgetRepeat: item.data["budgetrepeat"],
                  onPlusClick: budgetPlusOnClick,
                  onCardTap: openBudgetDetailPage,
                ))
            .toList());
  }

  void openBudgetDetailPage(String id, String budgetName, double budgetLimit, double budgetSpent, int budgetStartDate, int budgetRepeat) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BudgetDetails(
                user: widget.user,
                selectedBudgetID: id,
                selectedBudget: budgetName,
                selectedBudgetLimit: budgetLimit,
                selectedBudgetSpent: budgetSpent,
                selectBudgetStartDate: budgetStartDate,
                selectBudgetRepeat: budgetRepeat,
                currency: widget.currency,
                numBudgets: widget.numBudgets,
              )),
    );
  }

  void budgetPlusOnClick(String id, double budgetLimit, double budgetSpent) {
    setState(() {
      selectedBudgetID = id;
//      selectedBudgetName = budgetName;
      selectedBudgetLimit = budgetLimit;
      selectedBudgetSpent = budgetSpent;
    });

    showDialog(
        context: context,
        builder: (context) {
          return SelectExpenseCategory(setExpenseCategory: setExpenseCategory);
        });
  }

  void setExpenseCategory(String val, String displayName) {
    setState(() {
      category = val;
    });

    double budgetLeft = selectedBudgetLimit - selectedBudgetSpent;
    showDialog(
        context: context,
        builder: (context) {
          //return EnterBudgetValue(enterBudgetValue: enterBudgetValue, incomeOrExpense: incomeOrExpense, category: category, currentBalance: normalAccountBalance);
          return EnterBudgetValue(enterBudgetValue: enterBudgetValue, incomeOrExpense: 2, category: category, currentBalance: budgetLeft, displayName: displayName,);
        });
  }

  void enterBudgetValue(double val, String displayName) {
    setState(() {
      enterValue = val;
    });


    dynamic result = FireStoreService(uid: widget.user.uid).setNormalAccountEntry(2, displayName, new DateTime.now().millisecondsSinceEpoch, enterValue, widget.normalAccountBalance);

    try {
      FireStoreService(uid: widget.user.uid).setBudgetHistory(selectedBudgetID, selectedBudgetSpent, enterValue, displayName, new DateTime.now().millisecondsSinceEpoch);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

    // need to write to the database here.
    if (result != null) {
      setState(() {
        selectedBudgetName = "";
        selectedBudgetLimit = 0;
        selectedBudgetSpent = 0;
        enterValue = 0;
        category = '';
      });
    }
  }
}
