import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle generalBlackTextStyle1(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
        fontSize: fontSize ?? 32.sp,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w700,
        height: 1.3,
        letterSpacing: 1.1);
  }  static TextStyle generalBlackTextStyle2(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
        fontSize: fontSize ?? 24.sp,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.3,
        letterSpacing: 1.1);
  }
}
