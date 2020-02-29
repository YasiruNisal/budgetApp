import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplybudget/Components/autopaydetailscard.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/PopupDialogs/confirmDialog.dart';
import 'package:simplybudget/PopupDialogs/createOrEditAutoPay.dart';
import 'package:simplybudget/Services/firestore.dart';

class ListAutoPayHomeScreen extends StatefulWidget {
  final FirebaseUser user;
  final String currency;
  final int numAutoPay;
  final double normalAccountBalance;

  ListAutoPayHomeScreen({this.user, this.currency, this.numAutoPay, this.normalAccountBalance});

  @override
  _ListAutoPayHomeScreenState createState() => _ListAutoPayHomeScreenState();
}

class _ListAutoPayHomeScreenState extends State<ListAutoPayHomeScreen> {
  List<DocumentSnapshot> autoPayList;

  String selectedAutoPayID = "";
  String selectedAutoPayName = "";
  double selectedAutoPayLimit = 0;
  String category = "";
  double enterValue = 0;

  var fireBaseListener;

  @override
  void initState() {
    super.initState();
    fireBaseListener = FireStoreService(uid: widget.user.uid).autoPayList.listen((querySnapshot) {
      setState(() {
        autoPayList = querySnapshot.documents;
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
    if (autoPayList == null) {
      return Loading(size: 20.0);
    } else {
      return getAutoPayListWidget(autoPayList);
    }
  }

  Widget getAutoPayListWidget(List<DocumentSnapshot> autoPay) {
    return Column(
        children: autoPay
            .map((item) => AutoPayDetailCard(
                  user: widget.user,
                  id: item.documentID,
                  currency: widget.currency,
                  normalAccountBalance: widget.normalAccountBalance,
                  autoPayName: item.data["autopayname"],
                  autoPayAmount: item.data["autopayamount"].toDouble(),
                  autoPayStartDate: item.data["autopaystartdate"],
                  autoPayResetDate: item.data["autopayresetdate"],
                  autoPayRepeat: item.data["autopayrepeat"],
                  onEditClick: autoPayEditOnClick,
                  onDeleteClick: deleteThisAutoPay,
                ))
            .toList());
  }

  void autoPayEditOnClick(String id, String autoPayName, double autoPayAmount, int autoPayStartDate, int autoPayRepeat, int resetDate) {
    setState(() {
      selectedAutoPayID = id;
      selectedAutoPayLimit = autoPayAmount;
    });

    showDialog(
        context: context,
        builder: (context) {
          return CreateOrEditAutoPay(
            newAutoPaySet: _saveEditAutoPay,
            newOrEdit: "Edit Auto Payment",
            createOrSave: "Save",
            autoPayName: autoPayName,
            autoPayAmount: autoPayAmount,
            autoPayStartDate: autoPayStartDate,
            autoPayRepeatPeriod: autoPayRepeat,
          );
        });
  }

  void _saveEditAutoPay(String autoPayName, double amount, DateTime unixTime, int repeatPeriod, int resetDate) {
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
      name = "Auto Payment";
    }

    print(repeatPeriod);
    if (repeatPeriod == null) {
      //'Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'
      repeatPeriod = 9;
    }

    try {
      FireStoreService(uid: widget.user.uid).editAutoPay(selectedAutoPayID, name, autoPayAmount, pickedTime, repeatPeriod, resetDate);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

  }

  void deleteThisAutoPay(String id) {
    selectedAutoPayID = id;
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            onClickYes: deleteBudget,
            question: "Are you sure you want to delete?",
          );
        });
  }

  void deleteBudget() {
    try {
      FireStoreService(uid: widget.user.uid).deleteAutoPay(selectedAutoPayID, widget.numAutoPay);
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }
  }
}
