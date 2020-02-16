import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplybudget/Components/loading.dart';
import 'package:simplybudget/PopupDialogs/editaccountdetails.dart';
import 'package:simplybudget/Services/firestore.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:jiffy/jiffy.dart';

class SavingsDetails extends StatefulWidget {
  final FirebaseUser user;
  final String selectAccountName;
  final double selectAccountValue;
  final int accountCreated;
  final String currency;

  SavingsDetails({this.user, this.selectAccountName, this.selectAccountValue, this.accountCreated, this.currency});

  @override
  _SavingsDetailsState createState() => _SavingsDetailsState();
}

class _SavingsDetailsState extends State<SavingsDetails> with TickerProviderStateMixin {
  TabController _tabController;
  List<DocumentSnapshot> walletHistoryList;
  int currentPosition = 0;
  List<String> tabStringList;
  List<Map> startEndDates = List<Map>();
  int initStartTime = 0;
  int initEndTime = 0;
  String selectAccountName = "Loading";
  double selectAccountValue = 0.0;

  var fireBaseListener;


  @override
  void initState() {
    super.initState();

    tabStringList = getTabList(widget.accountCreated);
    _tabController = TabController(length: tabStringList.length, vsync: this, initialIndex: tabStringList.length - 1);
    _tabController.addListener(_handleTabChange);

    setState(() {
      selectAccountName =  widget.selectAccountName;
      selectAccountValue = widget.selectAccountValue;
    });

    fireBaseListener = FireStoreService(uid: widget.user.uid).savingsAccountHistoryList(initStartTime, initEndTime).listen((querySnapshot) {
      setState(() {
        walletHistoryList = querySnapshot.documents;
      });
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => callAfterBuild(context));
  }

  @override
  void dispose() {
    fireBaseListener?.cancel();
    super.dispose();
  }


  void callAfterBuild(context) {
    if(selectAccountValue == 0.0){
      editAccount();
    }

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
            backgroundColor: MyColors.MainFade1,
            expandedHeight: 170.0,
            floating: true,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  editAccount();
                },
                color: MyColors.WHITE,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(selectAccountName[0].toUpperCase() + selectAccountName.substring(1), style: TextStyle(fontSize: 15.0, color: MyColors.WHITE)),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Net Balance ',
                          style: TextStyle(fontSize: 20.0, color: MyColors.WHITE, fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.currency + " " + formatMoney(selectAccountValue),
                          style: TextStyle(fontSize: 45.0, color: MyColors.WHITE, fontWeight: FontWeight.w200),
                        ),

                      ],
                    ),
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

  void editAccount() {
    showDialog(
        context: context,
        builder: (context) {
          return EditAccountDetails(
            accountName: widget.selectAccountName,
            accountAmount: widget.selectAccountValue,
            whichAccount: 1,
            enterAccountDetails: saveEditAccount,
          );
        });
  }

  void saveEditAccount(String name, double newNetBalance, int whichAccount ) async{
    setState(() {
      selectAccountValue = newNetBalance;
      selectAccountName = name;
    });

    dynamic result = await FireStoreService(uid: widget.user.uid).editAccountEntry("Account Edited", newNetBalance, name, whichAccount);


  }


//--------------------------------------------------------//
// Callback function when a tab is changed
//--------------------------------------------------------//
  void _handleTabChange() {
    fireBaseListener = FireStoreService(uid: widget.user.uid).savingsAccountHistoryList(startEndDates[_tabController.index]["start"], startEndDates[_tabController.index]["end"]).listen((querySnapshot) {
      setState(() {
        walletHistoryList = querySnapshot.documents;
      });
    });
  }

//--------------------------------------------------------//
// Creates a list of day/month for the tabs
//--------------------------------------------------------//
  List<String> getTabList(int startDate) {
    int firstDayOfMonthAccount = DateTime(DateTime.fromMillisecondsSinceEpoch(startDate).year, DateTime.fromMillisecondsSinceEpoch(startDate).month, DateTime.fromMillisecondsSinceEpoch(startDate).day)
        .add(Duration(days: 1))
        .millisecondsSinceEpoch;
    int lastDayOfThisMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).millisecondsSinceEpoch;

    int today = DateTime.now().millisecondsSinceEpoch;

    List<String> tabList = <String>[];
    int addTime = firstDayOfMonthAccount;
    int prevTime = firstDayOfMonthAccount;

    while (addTime < lastDayOfThisMonth) {
      prevTime = addTime;

      DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(addTime).year, DateTime.fromMillisecondsSinceEpoch(addTime).month, 1);
      var jiffyTime = Jiffy(dt);
      addTime = jiffyTime.add(months: 1).millisecondsSinceEpoch;

      int displayTime = jiffyTime.subtract(duration: Duration(days: 1)).millisecondsSinceEpoch;

      tabList.add(DateTime.fromMillisecondsSinceEpoch(prevTime).day.toString() +
          "/" +
          DateTime.fromMillisecondsSinceEpoch(prevTime).month.toString() +
          " - " +
          (DateTime.fromMillisecondsSinceEpoch(displayTime).day).toString() +
          "/" +
          DateTime.fromMillisecondsSinceEpoch(displayTime).month.toString());
      startEndDates.add({"start": prevTime, "end": addTime});
    }

    initStartTime = prevTime;
    initEndTime = addTime;

    return tabList;
  }

  //--------------------------------------------------------//
//
//--------------------------------------------------------//
  Widget checkIfEmpty() {
    List<DocumentSnapshot> historyList = walletHistoryList;
    int length = 0;

    if (historyList == null) {
      return Loading(size: 20.0);
    } else {
      if (historyList.length == 0) {
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
                    opacity: _shouldShowHeader(currentPosition, historyList.length, historyList) ? 0.0 : 1.0,
                    child: _headerBuilder(context, currentPosition >= 0 ? currentPosition : 0, historyList),
                  ),
                  top: 0.0 + (5),
                  left: 0.0 + (5),
                ),
                ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: historyList.length,
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

  Widget budgetDetails(String budgetName, double budgetSpent, int incomeExpense) {
    Color amountColor = MyColors.TextSecondColor;
    if (incomeExpense == 1) {
      amountColor = MyColors.GREEN;
    } else if (incomeExpense == 2) {
      amountColor = MyColors.RED;
    } else {
      amountColor = MyColors.BLUE;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            color: MyColors.WHITE,
            alignment: Alignment.topLeft,
            width: 140,
            child: Text(
              budgetName[0].toUpperCase() + budgetName.substring(1),
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
            )),
        Container(
            color: MyColors.WHITE,
            alignment: Alignment.topLeft,
            width: 100,
            child: Text(
              widget.currency + " " + budgetSpent.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18.0,
                color: amountColor,
              ),
            )),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index, List<DocumentSnapshot> historyList) {
    return budgetDetails(historyList[index].data["incomeexpensecategory"], historyList[index].data["amount"], historyList[index].data["inout"]);
  }

  Widget _headerBuilder(BuildContext context, int index, List<DocumentSnapshot> historyList) {
    return new SizedBox(
        width: 50.0,
        child: dayFromUnix(historyList[index].data["timestamp"]
//                        style: Theme.of(context).textTheme.headline,
            ));
  }

  bool _shouldShowHeader(int position, int listLength, List<DocumentSnapshot> historyList) {
    if (position < 0) {
      return true;
    }
    if (position == 0 && currentPosition < 0) {
      return true;
    }

    if (position != 0 && position != currentPosition && !_hasSameHeader(position, position - 1, historyList)) {
      return true;
    }

    if (position != listLength - 1 && !_hasSameHeader(position, position + 1, historyList) && position == currentPosition) {
      return true;
    }
    return false;
  }

  bool _hasSameHeader(int a, int b, List<DocumentSnapshot> historyList) {
    return DateTime.fromMillisecondsSinceEpoch(historyList[a].data["timestamp"]).day.toString() == DateTime.fromMillisecondsSinceEpoch(historyList[b].data["timestamp"]).day.toString();
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
      color: MyColors.WHITE,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
