import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CreateOrEditBudget extends StatefulWidget {
  final void Function(String, double, DateTime, int, int) newBudgetSet;
  final String newOrEdit;
  final String budgetName;
  final double budgetLimit;
  final int budgetStartDate;
  final int budgetRepeatPeriod;
  final String createOrSave;

  CreateOrEditBudget({this.newBudgetSet, this.newOrEdit, this.createOrSave, this.budgetName, this.budgetLimit, this.budgetStartDate, this.budgetRepeatPeriod});

  @override
  _CreateOrEditBudgetState createState() => _CreateOrEditBudgetState();
}

class _CreateOrEditBudgetState extends State<CreateOrEditBudget> {
  final enterNameController = TextEditingController();

  final enterValController = TextEditingController();

  String budgetName = "";

  double budgetMaxValue = 0;

  String pickedStartDate = "Pick Start Date";

  DateTime unixPickedStartDate;

  String pickedRepeat = "Repeat Period";

  int pickedRepeatFromArray = 9;

  int unixRepeatTime = 0;

  @override
  initState() {
    super.initState();
    // Add listeners to this class

    if (widget.budgetStartDate != null) {
      int year = DateTime.fromMillisecondsSinceEpoch(widget.budgetStartDate).year;
      int month = DateTime.fromMillisecondsSinceEpoch(widget.budgetStartDate).month;
      int day = DateTime.fromMillisecondsSinceEpoch(widget.budgetStartDate).day;
      DateTime startDate = DateTime(year, month, day);
      unixPickedStartDate = startDate;
    } else {
      unixPickedStartDate = DateTime.now();
    }

    widget.budgetName != null ? enterNameController.text = widget.budgetName : budgetName = "";
    widget.budgetLimit != null ? enterValController.text = widget.budgetLimit.toString() : budgetMaxValue = 0;
    widget.budgetStartDate != null ? pickedStartDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(unixPickedStartDate) : pickedRepeat = "Repeat Period";
    widget.budgetRepeatPeriod != null ? pickedRepeat = repeatPeriods[widget.budgetRepeatPeriod] : pickedRepeat = "Repeat Period";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(
          widget.newOrEdit,
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Container(
            height: 400.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextField(
                      controller: enterNameController,
                      cursorColor: MyColors.MainFade2,
                      decoration: InputDecoration(
                        labelText: 'Budget Name',
                        labelStyle: new TextStyle(color: MyColors.MainFade2),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors.MainFade2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      controller: enterValController,
                      cursorColor: MyColors.MainFade2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '\$ Max Limit',
                        labelStyle: new TextStyle(color: MyColors.MainFade2),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors.MainFade2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    FlatButton(
                        color: MyColors.MainFade2,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 3, 5), maxTime: DateTime(2035, 6, 7), onChanged: (date) {
                          }, onConfirm: (date) {
                            setState(() {
                              unixPickedStartDate = DateTime(date.year, date.month, date.day); //DateTime.parse(date.toString()).millisecondsSinceEpoch;
                              pickedStartDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(date);
                            });
                          }, currentTime: unixPickedStartDate, locale: LocaleType.en);
                        },
                        child: Text(
                          pickedStartDate,
                          style: TextStyle(color: MyColors.WHITE),
                        )),
                    SizedBox(
                      height: 15.0,
                    ),
                    DropdownButton<String>(
                      hint: Text(pickedRepeat),
                      items: repeatPeriods.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(color: MyColors.MainFade1),
                          ),
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          pickedRepeat = selected;
                          pickedRepeatFromArray = repeatPeriods.indexOf(selected);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FlatButton(
                      color: MyColors.MainFade2,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        _dismissDialog(context);
                        Map duration = returnBudgetDuration(pickedRepeatFromArray);
                        int resetDate = unixPickedStartDate.millisecondsSinceEpoch;

                        DateTime dt = DateTime(DateTime.fromMillisecondsSinceEpoch(resetDate).year, DateTime.fromMillisecondsSinceEpoch(resetDate).month, DateTime.fromMillisecondsSinceEpoch(resetDate).day);
                        var jiffyTime = Jiffy(dt);

                        if (duration["period"] == "days") {
                          resetDate = jiffyTime.add(days: duration["time"]).millisecondsSinceEpoch;
                        } else if (duration["period"] == "months") {
                          resetDate = jiffyTime.add(months: duration["time"]).millisecondsSinceEpoch;
                        } else if (duration["period"] == "years") {
                          resetDate = jiffyTime.add(years: duration["time"]).millisecondsSinceEpoch;
                        }
//                        widget.enterBudgetValue( double.tryParse(enterValController.text));
                        widget.newBudgetSet(enterNameController.text, double.tryParse(enterValController.text), unixPickedStartDate, pickedRepeatFromArray, resetDate);
                      },
                      child: Text(
                        widget.createOrSave,
                        style: TextStyle(color: MyColors.WHITE),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  var repeatPeriods = <String>['Everyday', '2 Days', 'Every Week', 'Every 2 Week', 'Every 4 Week', 'Monthly', 'Every 2 Months', 'Every 3 Months', 'Every 6 Months', 'Every Year'];

  _dismissDialog(context) {
    Navigator.pop(context);
  }


  Map returnBudgetDuration(int repeatPeriod) {
    switch (repeatPeriod) {
      case 0:
        return {"period": "days", "time": 1};
        break;
      case 1:
        return {"period": "days", "time": 2};
        break;
      case 2:
        return {"period": "days", "time": 7};
        break;
      case 3:
        return {"period": "days", "time": 14};
        break;
      case 4:
        return {"period": "days", "time": 28};
        break;
      case 5:
        return {"period": "months", "time": 1};
        break;
      case 6:
        return {"period": "months", "time": 2};
        break;
      case 7:
        return {"period": "months", "time": 3};
        break;
      case 8:
        return {"period": "months", "time": 6};
        break;
      case 9:
        return {"period": "years", "time": 1};
        break;
      default:
        return {"period": "years", "time": 1};
        break;
    }
  }
}
