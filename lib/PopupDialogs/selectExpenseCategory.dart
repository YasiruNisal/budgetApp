import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class SelectExpenseCategory extends StatelessWidget {
  final void Function(String) setExpenseCategory;

  SelectExpenseCategory({this.setExpenseCategory});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Expense Category',
        textAlign: TextAlign.center,
      ),
      content: Container(
        // Specify some width
        width: MediaQuery.of(context).size.width * .9,
        child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            padding: const EdgeInsets.all(2.0),
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            children: <Expense>[
              Expense(text: 'coffee', color: MyColors.ExpenseCategory1),
              Expense(text: 'groceries', color: MyColors.ExpenseCategory1),
              Expense(text: 'restaurant', color: MyColors.ExpenseCategory1),
              Expense(text: 'fuel', color: MyColors.ExpenseCategory2),
              Expense(text: 'parking', color: MyColors.ExpenseCategory2),
              Expense(text: 'car insurance', color: MyColors.ExpenseCategory2),
              Expense(
                  text: 'car maintenance', color: MyColors.ExpenseCategory2),
              Expense(text: 'car rental', color: MyColors.ExpenseCategory2),
              Expense(
                  text: 'wellness & beauty', color: MyColors.ExpenseCategory3),
              Expense(text: 'tv streaming', color: MyColors.ExpenseCategory3),
              Expense(text: 'doctor', color: MyColors.ExpenseCategory3),
              Expense(text: 'hobbies', color: MyColors.ExpenseCategory3),
              Expense(text: 'fitness', color: MyColors.ExpenseCategory3),
              Expense(
                  text: 'public transport', color: MyColors.ExpenseCategory4),
              Expense(text: 'taxi', color: MyColors.ExpenseCategory4),
              Expense(text: 'internet', color: MyColors.ExpenseCategory5),
              Expense(text: 'phone', color: MyColors.ExpenseCategory5),
              Expense(text: 'stationery', color: MyColors.ExpenseCategory6),
              Expense(text: 'pets', color: MyColors.ExpenseCategory6),
              Expense(text: 'kids', color: MyColors.ExpenseCategory6),
              Expense(text: 'jewels', color: MyColors.ExpenseCategory6),
              Expense(text: 'home & garden', color: MyColors.ExpenseCategory6),
              Expense(text: 'gifts', color: MyColors.ExpenseCategory6),
              Expense(text: 'beauty', color: MyColors.ExpenseCategory6),
              Expense(text: 'electronic', color: MyColors.ExpenseCategory6),
              Expense(text: 'chemist', color: MyColors.ExpenseCategory6),
              Expense(
                  text: 'clothes & shoes', color: MyColors.ExpenseCategory6),
              Expense(
                  text: 'energy & utility', color: MyColors.ExpenseCategory7),
              Expense(text: 'maintenance', color: MyColors.ExpenseCategory7),
              Expense(text: 'mortgage', color: MyColors.ExpenseCategory7),
              Expense(text: 'rent', color: MyColors.ExpenseCategory7),
              Expense(
                  text: 'property insurance', color: MyColors.ExpenseCategory7),
              Expense(text: 'fines', color: MyColors.ExpenseCategory8),
              Expense(text: 'life insurance', color: MyColors.ExpenseCategory8),
              Expense(text: 'tax & interest', color: MyColors.ExpenseCategory8),
            ].map((Expense url) {
              return GridTile(
                  child: gridIcon('assets/expense/${url.text}.png', url.text,
                      url.color, context));
            }).toList()),
      ),
    );
  }

  Widget gridIcon(
      String url, String text, Color bgColor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissDialog(context);
        setExpenseCategory(text);
      },
      child: Container(
        child: Column(
          children: <Widget>[
//            CircleAvatar(
//              backgroundImage: AssetImage(url),
//              radius: 20.0,
//              backgroundColor: bgColor,
//            ),
            Container(
              decoration: new BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),  ),
              ),
              height: 40,
              width: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.asset(url),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text[0].toUpperCase() + text.substring(1),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}

class Expense {
  String text;
  Color color;

  Expense({this.text, this.color});
}
