import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final reference = Firestore.instance;
  final CollectionReference userCollection = reference.collection("user");
  final String uid;
  FireStoreService({this.uid});

  Future setInitialAccountValues(String name1, double value1, String name2, double value2) async {
    return await userCollection.document(uid).setData({
      "normalaccountname": name1,
      "normalaccountbalance": value1,
      "savingaccountname": name2,
      "savingaccountbalance": value2,
      "numberbudgets": 0,
      "currency": "\$",
      "accountcreated": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future setCurrency(
    String currency,
  ) async {
    return await userCollection.document(uid).updateData({
      "currency": currency,
    });
  }

  Future setNormalAccountEntry(int incomeExpense, String incomeExpenseCategory, int timestamp, double amount, double currentAccountBalance) async {
    WriteBatch batch = reference.batch();
    CollectionReference normalAccount = userCollection.document(uid).collection("normalaccount");
    DocumentReference normalAccountBalance = userCollection.document(uid);
    double newAccountBalance = 0;
    if (incomeExpense == 1) {
      newAccountBalance = currentAccountBalance + amount;
    } else if (incomeExpense == 2) {
      newAccountBalance = currentAccountBalance - amount;
    }
  print("&&&&&&&&&&&&&&&&&&&&&&&&");
    batch.setData(normalAccount.document(), {"incomeexpense": incomeExpense, "incomeexpensecategory": incomeExpenseCategory, "timestamp": timestamp, "amount": amount});

    batch.updateData(normalAccountBalance, {"normalaccountbalance": newAccountBalance});

    return await batch.commit();
  }

  Future transferToSavingAccount(double amount, double currentAccountBalance, double currentSavingBalance) async {
    WriteBatch batch = reference.batch();
    CollectionReference normalAccount = userCollection.document(uid).collection("normalaccount");
    CollectionReference savingAccount = userCollection.document(uid).collection("savingaccount");
    DocumentReference normalAccountBalance = userCollection.document(uid);

    double newAccountBalance = currentAccountBalance - amount;
    double newSavingBalance = currentSavingBalance + amount;

    batch.setData(normalAccount.document(), {"incomeexpense": 2, "incomeexpensecategory": "Transfered", "timestamp": new DateTime.now().millisecondsSinceEpoch, "amount": amount});

    batch.setData(savingAccount.document(), {"inout": 1, "incomeexpensecategory": "Transfered", "timestamp": new DateTime.now().millisecondsSinceEpoch, "amount": amount});

    batch.updateData(normalAccountBalance, {
      "normalaccountbalance": newAccountBalance,
      "savingaccountbalance": newSavingBalance,
    });

    return await batch.commit();
  }

  Future transferOutOfSavingAccount(double amount, double currentAccountBalance, double currentSavingBalance) async {
    WriteBatch batch = reference.batch();
    CollectionReference normalAccount = userCollection.document(uid).collection("normalaccount");
    CollectionReference savingAccount = userCollection.document(uid).collection("savingaccount");
    DocumentReference normalAccountBalance = userCollection.document(uid);

    double newAccountBalance = currentAccountBalance + amount;
    double newSavingBalance = currentSavingBalance - amount;

    batch.setData(normalAccount.document(), {"incomeexpense": 1, "incomeexpensecategory": "Transfered", "timestamp": new DateTime.now().millisecondsSinceEpoch, "amount": amount});

    batch.setData(savingAccount.document(), {"inout": 2, "incomeexpensecategory": "Transfered", "timestamp": new DateTime.now().millisecondsSinceEpoch, "amount": amount});

    batch.updateData(normalAccountBalance, {
      "normalaccountbalance": newAccountBalance,
      "savingaccountbalance": newSavingBalance,
    });

    return await batch.commit();
  }

  Future editAccountEntry(String incomeExpenseCategory, double newAccountBalance, String normalAccountName, int whichAccount) async {
    String name = "normalaccount";
    if (whichAccount == 1) {
      name = "savingaccount";
    }
    WriteBatch batch = reference.batch();
    CollectionReference normalAccount = userCollection.document(uid).collection(name);
    DocumentReference normalAccountBalance = userCollection.document(uid);

    batch.setData(normalAccount.document(), {"incomeexpense": 3, "incomeexpensecategory": incomeExpenseCategory, "timestamp": DateTime.now().millisecondsSinceEpoch, "amount": newAccountBalance});

    if (whichAccount == 1) {
      batch.updateData(normalAccountBalance, {"savingaccountbalance": newAccountBalance, "savingaccountname": normalAccountName});
    } else {
      batch.updateData(normalAccountBalance, {"normalaccountbalance": newAccountBalance, "normalaccountname": normalAccountName});
    }

    return await batch.commit();
  }

  Future setBudgetHistory(String budgetID, double currentSpentValue, double newEnteredValue, String expenseCategory, int timestamp) async {
    WriteBatch batch = reference.batch();
    CollectionReference budgetHistory = userCollection.document(uid).collection("newbudget").document(budgetID).collection("history");
    DocumentReference selectedBudget = userCollection.document(uid).collection("newbudget").document(budgetID);

    double newBudegtBalance = currentSpentValue + newEnteredValue;

    batch.setData(budgetHistory.document(), {"expensecategory": expenseCategory, "timestamp": timestamp, "amount": newEnteredValue});

    batch.updateData(selectedBudget, {"budgetspent": newBudegtBalance});

    return await batch.commit();
  }

  Future createNewAutoPay(String autoPayName, double autoPayAmount, int autoPayStartDate, int autoPayRepeat, int autoPayResetDate, int numberAutoPay) async {
    WriteBatch batch = reference.batch();
    DocumentReference normalAccountBalance = userCollection.document(uid);
    CollectionReference newBudget = userCollection.document(uid).collection("newautopay");

    batch.setData(newBudget.document(), {
      "autopayname": autoPayName,
      "autopayamount": autoPayAmount,
      "autopaystartdate": autoPayStartDate,
      "autopayresetdate": autoPayResetDate,
      "autopayrepeat": autoPayRepeat,
    });

    batch.updateData(normalAccountBalance, {"numberautopay": numberAutoPay + 1});

    return await batch.commit();
  }

  Future editAutoPay(
    String autoPayID,
    String autoPayName,
    double autoPayAmount,
    int autoPayStartDate,
    int autoPayRepeat,
    int autoPayResetDate,
  ) async {
    DocumentReference newBudget = userCollection.document(uid).collection("newautopay").document(autoPayID);

    return await newBudget.updateData({
      "autopayname": autoPayName,
      "autopayamount": autoPayAmount,
      "autopaystartdate": autoPayStartDate,
      "autopayresetdate": autoPayResetDate,
      "autopayrepeat": autoPayRepeat,
    });
  }

  Future resetAutoPay(String autoPayID, double autoPayAmount, int autoPayResetDate) async {

  return await userCollection.document(uid).collection("newautopay").document(autoPayID).updateData({
      "autopayresetdate": autoPayResetDate,
    });
  }

  Future addAutoPayHistory( String autoPayName, double autoPayAmount, int autoPayResetDate, double previousBalance) async {
    WriteBatch batch = reference.batch();

    double newAccountBalance = previousBalance - autoPayAmount;

    CollectionReference normalAccount = userCollection.document(uid).collection("normalaccount");
    batch.setData(normalAccount.document(), {"incomeexpense": 2, "incomeexpensecategory": autoPayName, "timestamp": autoPayResetDate, "amount": autoPayAmount});
    DocumentReference normalAccountBalance = userCollection.document(uid);
    batch.updateData(normalAccountBalance, {"normalaccountbalance": newAccountBalance,});
    return await batch.commit();
  }

  Future deleteAutoPay(String budgetID, int numberBudgets) async {
    WriteBatch batch = reference.batch();

    DocumentReference newBudget = userCollection.document(uid).collection("newautopay").document(budgetID);
    batch.delete(newBudget);

    DocumentReference normalAccountBalance = userCollection.document(uid);
    batch.updateData(normalAccountBalance, {"numberautopay": numberBudgets - 1});

    return await batch.commit();
  }

  Future createNewBudget(String budgetName, double budgetLimit, int budgetStartDate, int budgetRepeat, int budgetResetDate, int numberBudgets) async {
    WriteBatch batch = reference.batch();
    DocumentReference normalAccountBalance = userCollection.document(uid);
    CollectionReference newBudget = userCollection.document(uid).collection("newbudget");

    batch.setData(newBudget.document(), {
      "budgetname": budgetName,
      "budgetlimit": budgetLimit,
      "budgetstartdate": budgetStartDate,
      "budgetresetdate": budgetResetDate,
      "budgetrepeat": budgetRepeat,
      "budgetspent": 0,
    });

    batch.updateData(normalAccountBalance, {"numberbudgets": numberBudgets + 1});

    return await batch.commit();
  }

  Future editBudget(
    String budgetID,
    String budgetName,
    double budgetLimit,
    int budgetStartDate,
    int budgetResetDate,
    int budgetRepeat,
  ) async {
    DocumentReference newBudget = userCollection.document(uid).collection("newbudget").document(budgetID);

    return await newBudget.updateData({
      "budgetname": budgetName,
      "budgetlimit": budgetLimit,
      "budgetstartdate": budgetStartDate,
      "budgetresetdate": budgetResetDate,
      "budgetrepeat": budgetRepeat,
    });
  }

  Future resetBudget(
    String budgetID,
    int budgetResetDate,
    double budgetSpent,
  ) async {
    DocumentReference newBudget = userCollection.document(uid).collection("newbudget").document(budgetID);

    return await newBudget.updateData({
      "budgetresetdate": budgetResetDate,
      "budgetspent": budgetSpent,
    });
  }

  Future deleteBudget(String budgetID, int numberBudgets) async {
    WriteBatch batch = reference.batch();

    DocumentReference newBudget = userCollection.document(uid).collection("newbudget").document(budgetID);
    batch.delete(newBudget);

    DocumentReference normalAccountBalance = userCollection.document(uid);
    batch.updateData(normalAccountBalance, {"numberbudgets": numberBudgets - 1});

    return await batch.commit();
  }

  Future setInitialSavingAccount() async {
    return await userCollection.document(uid).collection("savingaccount").add({});
  }

  Future setInitialBudget() async {
    return await userCollection.document(uid).collection("budgets").add({});
  }

  Future getAccountData() async {
    return await userCollection.document(uid).get(source: Source.server);
  }

  Stream<DocumentSnapshot> get accountData {
    return userCollection.document(uid).snapshots();
  }

  Stream<QuerySnapshot> get budgetList {
    return userCollection.document(uid).collection("newbudget").snapshots();
  }

  Stream<QuerySnapshot> get autoPayList {
    return userCollection.document(uid).collection("newautopay").snapshots();
  }

  Stream<QuerySnapshot> budgetHistoryList(String budgetID, int start, int end) {
    return userCollection
        .document(uid)
        .collection("newbudget")
        .document(budgetID)
        .collection("history")
        .where("timestamp", isGreaterThan: start)
        .where("timestamp", isLessThanOrEqualTo: end)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> walletNormalAccountHistoryList(int start, int end) {
    return userCollection
        .document(uid)
        .collection("normalaccount")
        .where("timestamp", isGreaterThanOrEqualTo: start)
        .where("timestamp", isLessThan: end)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> savingsAccountHistoryList(int start, int end) {
    return userCollection
        .document(uid)
        .collection("savingaccount")
        .where("timestamp", isGreaterThanOrEqualTo: start)
        .where("timestamp", isLessThan: end)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
