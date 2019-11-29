import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  static final  reference = Firestore.instance;
  final CollectionReference userCollection = reference.collection("user");
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
      "accountcreated":DateTime.now(),
    });
  }

  Future setNormalAccountEntry(int incomeExpense, String incomeExpenseCategory, int timestamp, double amount, double currentAccountBalance) async
  {
    WriteBatch batch = reference.batch();
    CollectionReference normalAccount = userCollection.document(uid).collection("normalaccount");
    DocumentReference normalAccountBalance = userCollection.document(uid);
    double newAccountBalance = 0;
    if(incomeExpense == 1 ){
      newAccountBalance = currentAccountBalance + amount;
    }else if(incomeExpense == 2){
       newAccountBalance = currentAccountBalance - amount;
    }


    batch.setData(normalAccount.document(),
        {
          "incomeexpense": incomeExpense,
          "incomeexpensecategory":  incomeExpenseCategory,
          "timestamp": timestamp,
          "amount":amount
        });

    batch.updateData(normalAccountBalance, {"normalaccountbalance" : newAccountBalance});

    return await batch.commit();
  }

  Future setBudgetHistory(String budgetName, double currentSpentValue, double newEnteredValue, String expenseCategory, int timestamp) async
  {
    WriteBatch batch = reference.batch();
    CollectionReference budgetHistory = userCollection.document(uid).collection("newbudget").document(budgetName).collection("history");
    DocumentReference selectedBudget = userCollection.document(uid).collection("newbudget").document(budgetName);

    double newBudegtBalance = currentSpentValue + newEnteredValue;

    batch.setData(budgetHistory.document(),
        {
          "expensecategory":  expenseCategory,
          "timestamp": timestamp,
          "amount":newEnteredValue
        });

    batch.updateData(selectedBudget, {"budgetspent" : newBudegtBalance});

    return await batch.commit();
  }

  Future createNewBudget(String budgetName, double budgetLimit, int budgetStartDate, int budgetRepeat, int numberBudgets) async
  {
    WriteBatch batch = reference.batch();
    DocumentReference normalAccountBalance = userCollection.document(uid);
    DocumentReference newBudget = userCollection.document(uid).collection("newbudget").document(budgetName.toLowerCase());

    batch.setData( newBudget, {
      "budgetname" : budgetName,
      "budgetlimit" : budgetLimit,
      "budgetstartdate" : budgetStartDate,
      "budgetrepeat" : budgetRepeat,
      "budgetspent" : 0,
    });

    batch.updateData(normalAccountBalance, {"numberbudgets" : numberBudgets + 1});

    return await batch.commit();
  }

  Future editBudget(String budgetName, double budgetLimit, int budgetStartDate, int budgetRepeat,) async
  {

    DocumentReference newBudget = userCollection.document(uid).collection("newbudget").document(budgetName.toLowerCase());

    return await newBudget.updateData({
      "budgetname" : budgetName,
      "budgetlimit" : budgetLimit,
      "budgetstartdate" : budgetStartDate,
      "budgetrepeat" : budgetRepeat,
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
    return userCollection.document(uid).snapshots();
  }

  Stream<QuerySnapshot> get budgetList {
    return userCollection.document(uid).collection("newbudget").snapshots();
  }

  Stream<QuerySnapshot>  budgetHistoryList(String budgetName, int start, int end) {
    return userCollection.document(uid).collection("newbudget").document(budgetName).collection("history").where("timestamp", isGreaterThan: start).where("timestamp", isLessThanOrEqualTo: end).orderBy("timestamp", descending: true).snapshots();
  }

  Stream<QuerySnapshot>  walletNormalAccountHistoryList(int start, int end) {
    return userCollection.document(uid).collection("normalaccount").where("timestamp", isGreaterThanOrEqualTo: start).where("timestamp", isLessThan: end).orderBy("timestamp", descending: true).snapshots();
  }


}