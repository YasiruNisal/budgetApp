import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<FirebaseUser> get User {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => user);
  }

  Future signInAnon() async {
    try
    {
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    }
    catch(error)
    {
      print(error.toString());
      return null;
    }
  }


  Future registerWithEmailAndPassword(String email, String password) async {
    try
    {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(error)
    {
      print(error.toString());
    }
  }

  Future signInwithEmailAndPassword(String email, String password) async {
    try
    {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(error)
    {
      print(error.toString());
    }
  }

  Future signOut() async {
    try
    {
      return await _auth.signOut();
    }
    catch(error)
    {
      print(error);
      return null;
    }
  }
}