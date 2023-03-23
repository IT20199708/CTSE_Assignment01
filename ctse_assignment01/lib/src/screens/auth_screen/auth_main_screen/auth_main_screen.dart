import 'package:ctse_assignment01/src/constants/colors/colors.dart';
import 'package:ctse_assignment01/src/constants/images/images.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_button/custom_button.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_headline_text/custom_headline_text.dart';
import 'package:ctse_assignment01/src/screens/auth_screen/signin_screen/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../constants/text/text.dart';
import '../../../custom_widget/custom_outlined_btn/custom_outlined_btn.dart';
import '../../../utils/shared_preferences/shared_preferences.dart';
import '../signup_screen/user_role_select/user_role_select.dart';

class AuthMainScreen extends StatefulWidget {
  const AuthMainScreen({Key? key}) : super(key: key);

  @override
  State<AuthMainScreen> createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> {
  @override
  void initState() {
    super.initState();
    AppSharedPreferences.setonBoardingState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:17.w),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Image(image: AssetImage(tAuthMainScreenImage)),
                  SizedBox(
                    height: 49.h,
                  ),
                  CustomHeadlineText(text: "Welcome!", textColor: tPrimaryColor),
                  SizedBox(
                    height: 56.h,
                  ),
                  Text(
                    tAuthScreenText,style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 56.h,
                  ),
                  CustomButton(
                      BtnText: 'Login', onPressed: () =>Get.to(()=>SignIn())),
                  SizedBox(
                    
                    height: 30.h,
                  ),
                  CustomOutlinedBtn(BtnText: "Register", onPressed: () =>Get.to(()=>UserRoleSelect())
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
