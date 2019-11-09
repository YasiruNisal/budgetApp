import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simplybudget/config/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.WHITE,
      child: Center(
        child: SpinKitRotatingCircle(
          color: MyColors.MainFade1,
          size: 50.0,
        ),
      ),
    );
  }
}
