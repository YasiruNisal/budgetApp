import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:simplybudget/wrapper.dart';

import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StreamProvider<FirebaseUser>.value(
    value: AuthService().User,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

          fontFamily: 'San',
          primaryColor: MyColors.MainFade2,
          accentColor: MyColors.MainFade1,
          secondaryHeaderColor: MyColors.MainFade1),

      home: Wrapper(),

    ),
  ));
}


//  Splash Screen
//  https://medium.com/flutter-community/flutter-2019-real-splash-screens-tutorial-16078660c7a1