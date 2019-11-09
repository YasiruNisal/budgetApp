import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplybudget/Screens/Authenticate/authenticate.dart';
import 'package:simplybudget/Screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    if(user == null)
      {
        return Authenticate();
      }
    else
      {
        return Home(user: user,);
      }




  }
}
