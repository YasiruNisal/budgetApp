import 'package:flutter/material.dart';
import 'package:simplybudget/Services/auth.dart';
import 'package:simplybudget/config/colors.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Image.asset("assets/images/icon.png",height: 150,),
                  SizedBox(
                    height: 60.0,
                  ),
                  Text("Register", style: TextStyle(fontSize: 30.0),),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
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
                  TextFormField(
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                  ButtonTheme(
                    minWidth: 150.0,
                    child: RaisedButton(
                      color: MyColors.MainFade1,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),

                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: MyColors.WHITE),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if(result == null){
                            setState(() {
                              error = 'Please supply a valid email';
                            });
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                      child: Text("Sign In", style: TextStyle( color: MyColors.MainFade2, fontSize: 15.0)),
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
