import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {


  final CollectionReference userCollection = Firestore.instance.collection("user");
  final String uid;
  FireStoreService( {this.uid} );


  Future setInitialAccountValues(String name1, double value1, String name2, double value2) async
  {
    return await userCollection.document(uid).setData({
      "normalaccountname" : name1,
      "normalaccountbalance": value1,
      "savingaccountname" : name2,
      "savingaccountbalance": value2,
    });
  }

  Future savingAccount(String name, double value) async
  {
    return await userCollection.document(uid).updateData({

    });
  }

  Future normalAccountBudget(String name, double value) async
  {
    return await userCollection.document(uid).collection("normalbudget").add({
      "budgetname" : name,
      "normalaccountbalance": value,
    });
  }



}