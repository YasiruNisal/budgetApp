import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simplybudget/Services/firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();



  Stream<FirebaseUser> get User {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => user);
  }

  Future signInWithGoogle() async {

    try
    {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return user;
    }
    catch(error)
    {
      return null;
    }

  }

  Future signOutGoogle() async{
    try
    {
      return await googleSignIn.signOut();
    }
    catch(error)
    {
      return null;
    }
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
      return null;
    }
  }


  Future registerWithEmailAndPassword(String email, String password) async {
    try
    {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await FireStoreService(uid: user.uid).setInitialAccountValues("Account Balance", 0.0, "Saving Account Balance", 0.0);
//      await FireStoreService(uid: user.uid).setInitialNormalAccount();
//      await FireStoreService(uid: user.uid).setInitialSavingAccount();
//      await FireStoreService(uid: user.uid).setInitialBudget();
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