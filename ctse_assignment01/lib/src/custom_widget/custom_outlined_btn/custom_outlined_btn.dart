

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors/colors.dart';

class CustomOutlinedBtn extends StatelessWidget {
   CustomOutlinedBtn({Key? key, this.BtnColor=tPrimaryColor, required this.BtnText, this.BtnIcon, this.IsIconBtn=false, required this.onPressed}) : super(key: key);
  final Color? BtnColor;
  final String BtnText ;
  final IconData? BtnIcon;
  final bool? IsIconBtn;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return  OutlinedButton.icon(
        label:IsIconBtn == true ? Icon(BtnIcon) : SizedBox(),
        icon: Text(BtnText),
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(5.h),
            minimumSize: Size.fromHeight(45.h),
            side: BorderSide(color: BtnColor!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0.r),
            )),
        onPressed: onPressed
    );
  }
}
