import 'package:ctse_assignment01/src/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String BtnText;
  final IconData? BtnIcon;
  final bool? IsIconBtn;
  final Color? BtnColor;
  final VoidCallback onPressed;
  final double? Btnwidth;
  CustomButton(
      {Key? key,
      required this.BtnText,
      this.BtnIcon,
      this.IsIconBtn = false,
      this.BtnColor = tPrimaryColor,
      required this.onPressed,
        this.Btnwidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label:Text(BtnText) ,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5.h),
        minimumSize: Btnwidth == null ? Size.fromHeight(45.h):null ,
         fixedSize: Btnwidth != null ? Size(Btnwidth!, 45.h) : null,
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          backgroundColor: BtnColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              side: BorderSide(color: BtnColor!))),
      icon: IsIconBtn == true ? Icon(BtnIcon) : SizedBox(),
    );
  }
}
