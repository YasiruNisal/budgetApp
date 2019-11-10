import 'package:flutter/material.dart';
import 'package:simplybudget/config/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainCard extends StatelessWidget {
  final String icon;
  final Color color;
  final Function onCardPress;
  final String mainText;
  final String mainValue;
  final Color mainValueColor;
  final bool isButtonVisible;
  final IconData buttonIcon;
  final String buttonText;
  final Function onButtonPress;
  final bool isSecondButtonVisible;
  final IconData secondButtonIcon;
  final String secondButtonText;
  final Function onSecondButtonPress;

  MainCard(
      {this.color,
      this.icon,
      this.onCardPress,
      this.mainText,
      this.mainValue,
      this.mainValueColor,
      this.isButtonVisible,
      this.buttonIcon,
      this.buttonText,
      this.onButtonPress,
      this.isSecondButtonVisible,
      this.secondButtonIcon,
      this.secondButtonText,
      this.onSecondButtonPress});

  @override
  Widget build(BuildContext context) {
    String takeButtonText = buttonText == null ? '' : buttonText;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              color: color,
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  icon,
                  semanticsLabel: 'Card Logo',
                  height: 40,
                  width: 40,
                  color: MyColors.WHITE,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: onCardPress,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: 130,
                        child: Text(
                          mainText,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: MyColors.TextMainColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            mainValue,
                            style: TextStyle(
                                fontSize: 22.0,
                                color: mainValueColor,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: isButtonVisible,
                      child:  GestureDetector(
                        onTap: onButtonPress,
                        child: Icon(
                          buttonIcon,
                          size: 25.0,

                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSecondButtonVisible,
                      child: GestureDetector(
                        onTap: onSecondButtonPress,
                        child: Icon(
                          secondButtonIcon,
                          size: 25.0,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
