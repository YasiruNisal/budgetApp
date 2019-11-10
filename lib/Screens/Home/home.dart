import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:simplybudget/Screens/Home/accountdetails.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  final FirebaseUser user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {




  @override
  Widget build(BuildContext context) {
    

//    print(widget.user);
    return StreamProvider<QuerySnapshot>.value(
      value: FireStoreService().accountData,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyColors.BackgroundColor,
          body:AccountDetails(user: widget.user,)
        ),
      ),
    );
  }


}
