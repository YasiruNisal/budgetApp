import 'package:flutter/material.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/Services/auth.dart';


import 'package:simplybudget/config/colors.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading  = false;

  var _email = TextEditingController();
  var _password = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(size: 50.0,) : Scaffold(
      backgroundColor: MyColors.WHITE,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  //--------------------------------------------------------//
                  // App Icon
                  //--------------------------------------------------------//
                  Image.asset("assets/images/icon.png",height: 150,),
                  SizedBox(
                    height: 60.0,
                  ),
                  Text("Sign In", style: TextStyle(fontSize: 30.0),),
                  SizedBox(
                    height: 20.0,
                  ),
                  //--------------------------------------------------------//
                  // Email Address text field
                  //--------------------------------------------------------//
                  TextFormField(
                    controller: _email,
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _emailFocus, _passwordFocus);
                    },
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
//                      labelStyle: new TextStyle(color: MyColors.MainFade2),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.MainFade2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //--------------------------------------------------------//
                  // Password text field
                  //--------------------------------------------------------//
                  TextFormField(
                    controller: _password,
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocus,
                    onFieldSubmitted: (value) async {
                      _passwordFocus.unfocus();
                      if(_formKey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInwithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            error = 'Please supply valid details';
                            loading = false;
                          });
                        }
                      }
                    },
                    validator: (val) => val.isEmpty ? 'Enter your password' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
//                      labelStyle: new TextStyle(color: MyColors.MainFade2),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.MainFade2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),),
                  //--------------------------------------------------------//
                  // Sign in button
                  //--------------------------------------------------------//
                  ButtonTheme(
                    minWidth: 150.0,
                    child: FlatButton(
                      color: MyColors.MainFade1,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),

                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: MyColors.WHITE),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          dynamic result = await _auth.signInwithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              error = 'Please supply valid details';
                            });
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  //--------------------------------------------------------//
                  // Sign in with google
                  //--------------------------------------------------------//
//                  _signInButton(_auth),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                      child: Text("Create a new account", style: TextStyle( color: MyColors.MainFade2, fontSize: 15.0)),
                      onTap: () {
                        widget.toggleView();
                      }
                  )
                ],
              ),
            )),
      ),
    );
  }
}

_fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

//--------------------------------------------------------//
// Google sign in button
//--------------------------------------------------------//
Widget _signInButton(AuthService auth) {
  return OutlineButton(
    splashColor: Colors.grey,
    onPressed: () async
    {
      dynamic result = await auth.signInWithGoogle();
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
