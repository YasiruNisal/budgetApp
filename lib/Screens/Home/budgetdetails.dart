import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

class BudgetDetails extends StatefulWidget  {
  final FirebaseUser user;
  final String selectedBudget;
  final double selectedBudgetLimit;
  final double selectedBudgetSpent;
  final int selectBudgetStartDate;
  final int selectBudgetRepeat;

  BudgetDetails({this.user, this.selectedBudget, this.selectedBudgetLimit, this.selectedBudgetSpent, this.selectBudgetStartDate, this.selectBudgetRepeat});

  @override
  _BudgetDetailsState createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> with TickerProviderStateMixin{
  TabController _tabController;
  List<DocumentSnapshot> budgetHistoryList;
  List<String> tabStringList;
  List<Map> startEndDates = List<Map>();
  int currentPosition = 0;
  int activeTab = 0;
  int initStartTime = 0;
  int initEndTime = 0;

  @override
  void initState() {
    super.initState();
    tabStringList = getTabList(widget.selectBudgetStartDate, widget.selectBudgetRepeat);
    _tabController =  TabController(length: tabStringList.length, vsync: this, initialIndex: tabStringList.length-1 );
    _tabController.addListener(_handleTabChange);


    FireStoreService(uid: widget.user.uid).budgetHistoryList(widget.selectedBudget.toLowerCase(), initStartTime, initEndTime).listen((querySnapshot) {
      setState(() {
        budgetHistoryList = querySnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color donutColor = MyColors.GREEN;

    double totalSpent = 0;
    budgetHistoryList.forEach((item) =>
      totalSpent += item["amount"]
    );
    double percentage = totalSpent / widget.selectedBudgetLimit;
    if (percentage > 1) {
      percentage = (totalSpent % widget.selectedBudgetLimit) / widget.selectedBudgetLimit;
      donutColor = MyColors.RED;
    }

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                  backgroundColor: MyColors.MainFade3,
                  expandedHeight: 330.0,
                  floating: true,
                  pinned: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                      color: MyColors.WHITE,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                      color: MyColors.WHITE,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.selectedBudget[0].toUpperCase() + widget.selectedBudget.substring(1), style: TextStyle(fontSize: 18.0, color: MyColors.WHITE)),
                    background: Padding(
                      padding: const EdgeInsets.only(top: 80.0, left: 10, right: 10.0),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text("\$ " + widget.selectedBudgetLimit.toStringAsFixed(2) + " Limit", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.0, color: MyColors.WHITE)),
                              ),
                            ),
                            Container(height: 25.0, color: MyColors.GREY, width: 1.0),
                            Container(
                              alignment: Alignment.topLeft,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text("\$ " + totalSpent.toStringAsFixed(2) + " Spent", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.0, color: MyColors.WHITE)),
                              ),
                            ),
                          ],
                        ),
                        CircularPercentIndicator(
                          radius: 170.0,
                          lineWidth: 20.0,
                          percent: percentage,
                          center: new Text(
                            (percentage * 100).toStringAsFixed(1) + " %",
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: MyColors.WHITE),
                          ),
                          progressColor: donutColor,
                        ),
                      ]),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: MyColors.MainFade3,
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: tabStringList
                          .map((item) => Tab(
                                child: Text(item, style: TextStyle(fontSize: 15),),
                              ))
                          .toList(),
                      onTap: (index){
                        FireStoreService(uid: widget.user.uid).budgetHistoryList(widget.selectedBudget.toLowerCase(), startEndDates[index]["start"], startEndDates[ index]["end"] ).listen((querySnapshot) {
                          setState(() {
                            budgetHistoryList = querySnapshot.documents;
                          });
                        });
                      },
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
                controller: _tabController,
                children: tabStringList
                    .map(
                      (item) => Container(
                        child: Center(
                          child: checkIfEmpty(),
                        ),
                      ),
                    )
                    .toList())));
  }

  void _handleTabChange() {
//    budgetHistoryList = null;
    print("Calling tabbar handler " + _tabController.index.toString());
    FireStoreService(uid: widget.user.uid).budgetHistoryList(widget.selectedBudget.toLowerCase(), startEndDates[ _tabController.index]["start"], startEndDates[ _tabController.index]["end"] ).listen((querySnapshot) {
      setState(() {
        budgetHistoryList = querySnapshot.documents;
      });
    });

  }

  Widget _itemBuilder(BuildContext context, int index,List<DocumentSnapshot> historyList) {
    return budgetDetails(historyList[index].data["expensecategory"], historyList[index].data["amount"]);
  }

  Widget _headerBuilder(BuildContext context, int index, List<DocumentSnapshot> historyList) {
    return new SizedBox(
        width: 50.0,
        child: dayFromUnix(historyList[index].data["timestamp"]
//                        style: Theme.of(context).textTheme.headline,
            ));
  }

  bool _shouldShowHeader(int position,  int listLength, List<DocumentSnapshot> historyList) {
    if (position < 0) {
      return true;
    }
    if (position == 0 && currentPosition < 0) {
      return true;
    }

    if (position != 0 && position != currentPosition && !_hasSameHeader(position, position - 1,  historyList)) {
      return true;
    }

    if (position != listLength - 1 && !_hasSameHeader(position, position + 1, historyList) && position == currentPosition) {
      return true;
    }
    return false;
  }

  bool _hasSameHeader(int a, int b, List<DocumentSnapshot> historyList) {
//                          return names[a].substring(0, 1) == names[b].substring(0, 1);
    return DateTime.fromMillisecondsSinceEpoch(historyList[a].data["timestamp"]).day.toString() == DateTime.fromMillisecondsSinceEpoch(historyList[b].data["timestamp"]).day.toString();
  }

  Widget checkIfEmpty() {

    List<DocumentSnapshot> historyList = budgetHistoryList;
    int length =  0;

    if (historyList == null) {
      return Loading(size: 20.0);
    } else {
      if (historyList.length == 0) {
        return Text(
          "Seems to be empty",
          textAlign: TextAlign.center,
        );
      } else {
        length = historyList.length;
        return Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
          child: Container(
            color: MyColors.WHITE,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: new Opacity(
                    opacity: _shouldShowHeader(currentPosition, historyList.length, historyList) ? 0.0 : 1.0,
                    child: _headerBuilder(context, currentPosition >= 0 ? currentPosition : 0, historyList),
                  ),
                  top: 0.0 + (5),
                  left: 0.0 + (5),
                ),
                ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: length,
                    itemExtent: 55.0,
                    itemBuilder: (BuildContext context, int index) {
                      return new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new FittedBox(
                            child: new Opacity(
                              opacity: _shouldShowHeader(index, historyList.length, historyList) ? 1.0 : 0.0,
                              child: _headerBuilder(context, index, historyList),
                            ),
                          ),
                          new Expanded(child: _itemBuilder(context, index, historyList))
                        ],
                      );
                    }),
              ],
            ),
          ),
        );
      }
    }
  }

  List<String> getTabList(int startDate, int repeatPeriod) {
    int today = DateTime.now().millisecondsSinceEpoch;
    List<String> tabList = <String>[];
    int addTime = startDate;
    int prevTime = startDate;
    Map duration = returnBudgetDuration(repeatPeriod);



    while (addTime < today) {
      prevTime = addTime;
      DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(addTime).year, DateTime.fromMillisecondsSinceEpoch(addTime).month, DateTime.fromMillisecondsSinceEpoch(addTime).day);
      var jiffyTime = Jiffy(dt);

      if (duration["period"] == "days") {
        addTime = jiffyTime.add(days: duration["time"]).millisecondsSinceEpoch;
      } else if (duration["period"] == "months") {
        addTime = jiffyTime.add(months: duration["time"]).millisecondsSinceEpoch;
      } else if (duration["period"] == "years") {
        addTime = jiffyTime.add(years: duration["time"]).millisecondsSinceEpoch;
      }


      tabList.add(DateTime.fromMillisecondsSinceEpoch(prevTime).day.toString() + "/" + DateTime.fromMillisecondsSinceEpoch(prevTime).month.toString() + " - " +(DateTime.fromMillisecondsSinceEpoch(addTime).day -1).toString() + "/" + DateTime.fromMillisecondsSinceEpoch(addTime).month.toString());
      startEndDates.add({"start": prevTime, "end":addTime});
    }

    initStartTime = prevTime;
    initEndTime = addTime;

    return tabList;
  }

  Widget budgetDetails(String budgetName, double budgetSpent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            width: 140,
            child: Text(
              budgetName[0].toUpperCase() + budgetName.substring(1),
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
        Container(
            alignment: Alignment.topLeft,
            width: 100,
            child: Text(
              "\$ " + budgetSpent.toStringAsFixed(2),
              style: TextStyle(fontSize: 18.0, color: MyColors.TextSecondColor),
            )),
      ],
    );
  }

  Widget dayFromUnix(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return Container(
      child: Row(
        children: <Widget>[
          Text(
            date.day.toString(),
            style: TextStyle(fontSize: 25.0),
          ),
          RotatedBox(quarterTurns: 3, child: Text(getMonthString(date.month)))
        ],
      ),
    );
  }

  Map returnBudgetDuration(int repeatPeriod) {
    switch (repeatPeriod) {
      case 1:
        return {"period": "days", "time": 1};
        break;
      case 2:
        return {"period": "days", "time": 2};
        break;
      case 3:
        return {"period": "days", "time": 7};
        break;
      case 4:
        return {"period": "days", "time": 14};
        break;
      case 5:
        return {"period": "days", "time": 28};
        break;
      case 6:
        return {"period": "months", "time": 1};
        break;
      case 7:
        return {"period": "months", "time": 2};
        break;
      case 8:
        return {"period": "months", "time": 3};
        break;
      case 9:
        return {"period": "months", "time": 6};
        break;
      case 10:
        return {"period": "years", "time": 1};
        break;
      default:
        return {"period": "years", "time": 1};
        break;
    }
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return '';
        break;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: MyColors.WHITE,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
