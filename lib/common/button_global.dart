import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonGlobal extends StatelessWidget {
  final String buttontext;
  final Decoration? buttonDecoration;

  var onPressed;

  ButtonGlobal(
      {required this.buttontext,
      this.buttonDecoration,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 6 * SizeConfigure.heightMultiplier,
        decoration: buttonDecoration,
        child: Center(
          child: Text(
            buttontext,
            style: kTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 1.8 * SizeConfigure.textMultiplier),
          ),
        ),
      ),
    );
  }
}

class ButtonGlobalWithoutIcon extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;

  var onPressed;
  final Color buttonTextColor;

  ButtonGlobalWithoutIcon(
      {required this.buttontext,
      required this.buttonDecoration,
      required this.onPressed,
      required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 6.0.h,
        decoration: buttonDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttontext,
              style: kTextStyle.copyWith(
                  color: buttonTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}
