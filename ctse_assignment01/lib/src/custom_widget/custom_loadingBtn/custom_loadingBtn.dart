import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoadingButton extends StatelessWidget {
  CustomLoadingButton({Key? key, required this.onPressed, required this.isLoading, required this.btnText}) : super(key: key);
  final VoidCallback onPressed;
  final bool isLoading;
  final String btnText;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(40),
        textStyle: TextStyle(fontSize:16)
      ),
      child: isLoading ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white,),
           SizedBox(width:24.w),
          Text('Loading...')
        ],
      ) : Text(btnText) ,
      onPressed:onPressed,
    );
  }
}
