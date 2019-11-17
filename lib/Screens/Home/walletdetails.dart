import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

class WalletDetails extends StatefulWidget {
  final String selectedBudget;
  final double selectedBudgetLimit;
  final double selectedBudgetSpent;

  WalletDetails({this.selectedBudget, this.selectedBudgetLimit, this.selectedBudgetSpent});

  @override
  _WalletDetailsState createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  @override
  Widget build(BuildContext context) {
    Color donutColor = MyColors.GREEN;
    double percentage = widget.selectedBudgetSpent / widget.selectedBudgetLimit;
    if (percentage > 1) {
      percentage = (widget.selectedBudgetSpent % widget.selectedBudgetLimit) / widget.selectedBudgetLimit;
      donutColor = MyColors.RED;
    }

    return Scaffold(
        backgroundColor: Color(0xFF7A9BEE),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(widget.selectedBudget[0].toUpperCase() + widget.selectedBudget.substring(1), style: TextStyle(fontSize: 25.0, color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: ListView(children: [
          Stack(children: [
            Container(height: MediaQuery.of(context).size.height + 200.0, width: MediaQuery.of(context).size.width, color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height +200,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: 'donut pie chart',
                    child: Container(
                        child: CircularPercentIndicator(
                          radius: 170.0,
                          lineWidth: 30.0,
                          percent: percentage,
                          center: new Text(
                            (percentage * 100).toStringAsFixed(1) + " %",
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          progressColor: donutColor,
                        ),
                        height: 200.0,
                        width: 200.0))),
            Positioned(
              top: 250.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Budget Info",
                      style: TextStyle(
                        fontSize: 22.0,
                      )),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text("\$ " + widget.selectedBudgetLimit.toStringAsFixed(2) + " Limit", style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                        ),
                      ),
                      Container(height: 25.0, color: Colors.grey, width: 1.0),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text("\$ " + widget.selectedBudgetSpent.toStringAsFixed(2) + " Spent", style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Budget',
                          style: TextStyle(
//                        fontFamily: 'Montserrat',
                              color: MyColors.TextMainColor,
                              fontSize: 20.0)),
                      SizedBox(width: 5.0),
                      Text('Spendings',
                          style: TextStyle(
//                        fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: MyColors.TextMainColor,
                              fontSize: 20.0))
                    ],
                  ),
                  Flex(
                      direction: Axis.vertical,
                      children:[ Container(
                        height: 500,
                        child: SideHeaderListView(
                          itemCount: names.length,
                          padding: new EdgeInsets.all(10.0),
                          itemExtend: 48.0,
                          headerBuilder: (BuildContext context, int index) {
                            return new SizedBox(
                                width: 32.0,
                                child: new Text(
                                  names[index].substring(0, 1),
//                        style: Theme.of(context).textTheme.headline,
                                ));
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return new Text(
                              names[index],
//                    style: Theme.of(context).textTheme.headline,
                            );
                          },
                          hasSameHeader: (int a, int b) {
                            return names[a].substring(0, 1) == names[b].substring(0, 1);
                          },
                        ),
                      ),]
                  ),
                ],
              ),
            ),
          ]),

        ]
        )
    );
  }

  static const names = const <String>[
    'Annie',
    'Arianne',
    'Bertie',
    'Bettina',
    'Bradly',
    'Caridad',
    'Carline',
    'Cassie',
    'Chloe',
    'Christin',
    'Clotilde',
    'Dahlia',
    'Dana',
    'Dane',
    'Darline',
    'Deena',
    'Delphia',
    'Donny',
    'Echo',
    'Else',
    'Ernesto',
    'Fidel',
    'Gayla',
    'Grayce',
    'Henriette',
    'Hermila',
    'Hugo',
    'Irina',
    'Ivette',
    'Jeremiah',
    'Jerica',
    'Joan',
    'Johnna',
    'Jonah',
    'Joseph',
    'Junie',
    'Linwood',
    'Lore',
    'Louis',
    'Merry',
    'Minna',
    'Mitsue',
    'Napoleon',
    'Paris',
    'Ryan',
    'Salina',
    'Shantae',
    'Sonia',
    'Taisha',
    'Zula',
  ];
}
