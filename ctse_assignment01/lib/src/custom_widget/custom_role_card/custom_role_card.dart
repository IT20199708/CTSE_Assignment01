import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors/colors.dart';

class CustomRoleCard extends StatelessWidget {
  CustomRoleCard({
    Key? key,
    required this.UserRole,
    required this.AssetsImage, required this.onPressed,
  }) : super(key: key);
  final String UserRole;
  final String AssetsImage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300.h,
      width: 230.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Text(UserRole),
          ),
          SizedBox(height: 50.h),
          buildShadow(true),
          Positioned(
            child: Container(
                width: 170.w,
                child: Image(image: AssetImage(AssetsImage)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ],
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black26 : Colors.white)),
          ),
          buildShadow(false)
        ],
      ),
    );
  }

  Positioned buildShadow(bool isShadow) {
    return Positioned(
        top: 220.h,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: isShadow ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (isShadow)
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                ]),
            child: !isShadow
                ? Container(
                    child: IconButton(
                        onPressed:onPressed,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )),
                    decoration: BoxDecoration(
                        color: tPrimaryColor,
                        borderRadius: BorderRadius.circular(30)))
                : Center(),
          ),
        ));
  }
}
