import 'package:ctse_assignment01/src/custom_widget/custom_headline_text/custom_headline_text.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_role_card/custom_role_card.dart';
import 'package:ctse_assignment01/src/screens/auth_screen/signup_screen/org_signup/org_signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/colors/colors.dart';
import '../../../../constants/images/images.dart';
import '../user_signup/user_signup.dart';

class UserRoleSelect extends StatelessWidget {
  const UserRoleSelect({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation: 0,
      ),
      body:Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal:20.w),
        child: Column(
          children: [
            CustomHeadlineText(text: "Select User Role",textColor: tPrimaryColor),
            SizedBox(height:30.h),
            CustomRoleCard(UserRole: "Sign Up As User",AssetsImage: tUserRole,onPressed:()=> Get.off(()=>UserSignUp(),transition: Transition.rightToLeftWithFade)),
            SizedBox(height:20.h),
            CustomRoleCard(UserRole:"Sign Up As Organization",AssetsImage:tOrgRole,onPressed:()=> Get.off(()=>OrgSignUp(),transition: Transition.rightToLeftWithFade))
          ],
        ),
      ) ,
    );
  }
}
