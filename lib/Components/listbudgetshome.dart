import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/budgetdetailscard.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/Services/firestore.dart';

class ListBudgetsHomeScreen extends StatefulWidget {
  final FirebaseUser user;

  ListBudgetsHomeScreen({this.user});

  @override
  _ListBudgetsHomeScreenState createState() => _ListBudgetsHomeScreenState();
}

class _ListBudgetsHomeScreenState extends State<ListBudgetsHomeScreen> {
  List<DocumentSnapshot> budgetList;

  @override
  void initState() {
    super.initState();
    FireStoreService(uid: widget.user.uid).budgetList.listen((querySnapshot) {
      setState(() {
        budgetList = querySnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (budgetList == null) {
      return Loading(size: 20.0);
    } else {
      print("COMING IN HERREE");
      return getBudgetListWidget(budgetList);
    }
  }

  Widget getBudgetListWidget(List<DocumentSnapshot> budgets) {
    return Column(
        children: budgets
            .map((item) => BudgetDetailCard(
                  budgetName: item.data["budgetname"],
                  budgetLimit: item.data["budgetlimit"].toDouble(),
                  budgetSpent: item.data["budgetspent"].toDouble(),
                ))
            .toList());
  }
}
