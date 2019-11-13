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
      "numberbudgets":0,
      "currency":"\$",
    });
  }

  Future setInitialNormalAccount() async
  {
    return await userCollection.document(uid).collection("normalaccount").add({
    });
  }

  Future setInitialSavingAccount() async
  {
    return await userCollection.document(uid).collection("savingaccount").add({
    });
  }

  Future setInitialBudget() async
  {
    return await userCollection.document(uid).collection("budgets").add({
    });
  }

  Future getAccountData () async
  {
    return await userCollection.document(uid).get(source: Source.server);
  }


  Stream<DocumentSnapshot> get accountData {
    print(uid);
    return userCollection.document(uid).snapshots();
  }


}