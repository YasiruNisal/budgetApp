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

    return Scaffold(
//      backgroundColor: Color(0xFF3700B3),
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: AccountDetails(
        user: widget.user,
      )),
    );
  }
}
