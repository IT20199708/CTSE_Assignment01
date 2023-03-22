import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeadlineText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? textSize;
  CustomHeadlineText({Key? key, required this.text,this.textColor = Colors.black, this.textSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: textSize ?? 24.sp,
      color:textColor
    ),
    );
  }
}
