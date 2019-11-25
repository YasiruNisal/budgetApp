import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:jiffy/jiffy.dart';

class WalletDetails extends StatefulWidget {
  final FirebaseUser user;
  final String selectAccountName;
  final double selectAccountValue;
  final int accountCreated;

  WalletDetails({this.user, this.selectAccountName, this.selectAccountValue, this.accountCreated});

  @override
  _WalletDetailsState createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> with TickerProviderStateMixin {
  TabController _tabController;
  List<DocumentSnapshot> walletHistoryList;
  int currentPosition = 0;
  List<String> tabStringList;
  List<Map> startEndDates = List<Map>();
  int initStartTime = 0;
  int initEndTime = 0;

  @override
  void initState() {
    super.initState();
    tabStringList = getTabList(widget.accountCreated);
    _tabController = TabController(length: tabStringList.length, vsync: this, initialIndex: tabStringList.length - 1);
    _tabController.addListener(_handleTabChange);

    FireStoreService(uid: widget.user.uid).walletNormalAccountHistoryList().listen((querySnapshot) {
      setState(() {
        walletHistoryList = querySnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
                color: MyColors.WHITE,
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {},
                color: MyColors.WHITE,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(widget.selectAccountName[0].toUpperCase() + widget.selectAccountName.substring(1), style: TextStyle(fontSize: 15.0, color: MyColors.WHITE)),
              background: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10.0),
                child: Center(
                  child: Text(
                    '\$ ' + formatMoney(widget.selectAccountValue),
                    style: TextStyle(fontSize: 45.0, color: MyColors.WHITE, fontWeight: FontWeight.w200),
                  ),
                ),
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
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 15),
                          ),
                        ))
                    .toList(),
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
              .toList()),
    ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return budgetDetails(walletHistoryList[index].data["incomeexpensecategory"], walletHistoryList[index].data["amount"], walletHistoryList[index].data["incomeexpense"]);
  }

  Widget _headerBuilder(BuildContext context, int index) {
    return new SizedBox(
        width: 50.0,
        child: dayFromUnix(walletHistoryList[index].data["timestamp"]
//                        style: Theme.of(context).textTheme.headline,
            ));
  }

  bool _shouldShowHeader(int position) {
    if (position < 0) {
      return true;
    }
    if (position == 0 && currentPosition < 0) {
      return true;
    }

    if (position != 0 && position != currentPosition && !_hasSameHeader(position, position - 1)) {
      return true;
    }

    if (position != walletHistoryList.length - 1 && !_hasSameHeader(position, position + 1) && position == currentPosition) {
      return true;
    }
    return false;
  }

  bool _hasSameHeader(int a, int b) {
//                          return names[a].substring(0, 1) == names[b].substring(0, 1);
    return DateTime.fromMillisecondsSinceEpoch(walletHistoryList[a].data["timestamp"]).day.toString() == DateTime.fromMillisecondsSinceEpoch(walletHistoryList[b].data["timestamp"]).day.toString();
  }

  void _handleTabChange() {
//    budgetHistoryList = null;
    print("Calling tabbar handler " + _tabController.index.toString());
//    FireStoreService(uid: widget.user.uid).budgetHistoryList(widget.selectedBudget.toLowerCase(), startEndDates[ _tabController.index]["start"], startEndDates[ _tabController.index]["end"] ).listen((querySnapshot) {
//      setState(() {
//        budgetHistoryList = querySnapshot.documents;
//      });
//    });
  }

  List<String> getTabList(int startDate) {
    DateTime firstDayOfMonthAccount = DateTime(DateTime.fromMillisecondsSinceEpoch(startDate).year, DateTime.fromMillisecondsSinceEpoch(startDate).month ,0).add( Duration(days: 1));
    DateTime lastDayOfThisMonth = DateTime( DateTime.now().year, DateTime.now().month + 1 ,0);

    int today = DateTime.now().millisecondsSinceEpoch;

    List<String> tabList = <String>[];
    int addTime = firstDayOfMonthAccount.millisecondsSinceEpoch;
    int prevTime = firstDayOfMonthAccount.millisecondsSinceEpoch;

    while (addTime < lastDayOfThisMonth.millisecondsSinceEpoch) {
      prevTime = addTime;

      DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(addTime).year, DateTime.fromMillisecondsSinceEpoch(addTime).month, 0);
      var jiffyTime = Jiffy(dt).add(months: 1);
      addTime = jiffyTime.millisecondsSinceEpoch;

      tabList.add(DateTime.fromMillisecondsSinceEpoch(prevTime).day.toString() +
          "/" +
          DateTime.fromMillisecondsSinceEpoch(prevTime).month.toString() +
          " - " +
          (DateTime.fromMillisecondsSinceEpoch(addTime).day ).toString() +
          "/" +
          DateTime.fromMillisecondsSinceEpoch(addTime).month.toString());
      startEndDates.add({"start": prevTime, "end": addTime});
    }

    initStartTime = prevTime;
    initEndTime = addTime;

    return tabList;
  }

  Widget checkIfEmpty() {
    if (walletHistoryList == null) {
      return Loading(size: 20.0);
    } else {
      if (walletHistoryList.length == 0) {
        return Text(
          "Seems to be empty",
          textAlign: TextAlign.center,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
          child: Container(
            color: MyColors.WHITE,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: new Opacity(
                    opacity: _shouldShowHeader(currentPosition) ? 0.0 : 1.0,
                    child: _headerBuilder(context, currentPosition >= 0 ? currentPosition : 0),
                  ),
                  top: 0.0 + (5),
                  left: 0.0 + (5),
                ),
                ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: walletHistoryList.length,
                    itemExtent: 55.0,
                    itemBuilder: (BuildContext context, int index) {
                      return new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new FittedBox(
                            child: new Opacity(
                              opacity: _shouldShowHeader(index) ? 1.0 : 0.0,
                              child: _headerBuilder(context, index),
                            ),
                          ),
                          new Expanded(child: _itemBuilder(context, index))
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

  Widget budgetDetails(String budgetName, double budgetSpent, int incomeExpense) {
    Color amountColor = MyColors.TextSecondColor;
    if (incomeExpense == 1) {
      amountColor = MyColors.GREEN;
    } else {
      amountColor = MyColors.RED;
    }
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
              style: TextStyle(
                fontSize: 18.0,
                color: amountColor,
              ),
            )),
      ],
    );
  }

  Widget dayFromUnix(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    print(date.month.toString());
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

  String formatMoney(double val) {
    NumberFormat format = NumberFormat('#,###,###.##');
    return format.format(val).toString();
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
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
