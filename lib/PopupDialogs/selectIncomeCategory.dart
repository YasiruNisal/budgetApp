import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';

class SelectIncomeCategory extends StatelessWidget {

  final void Function(String) setIncomeCategory;

  SelectIncomeCategory({this.setIncomeCategory});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Income Category',
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
            children: <String>[
              'salary',
              'wage',
              'check',
              'giftcard',
              'bonus',
              'dividends',
              'sale',
              'rental',
              'refund',
              'grants',
              'awards',
              'investments',
              'government',
              'lottery',
            ].map((String url) {
              return GridTile(
                  child: gridIcon('assets/income/${url}.png', url, context));
            }).toList()),
      ),
    );
  }

  Widget gridIcon(String url, String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissDialog(context);
        setIncomeCategory(text);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(url),
              radius: 20.0,
              backgroundColor: MyColors.TransparentBack,
            ),
            SizedBox(
              height: 5,
            ),
            Text(text[0].toUpperCase() + text.substring(1), textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}

