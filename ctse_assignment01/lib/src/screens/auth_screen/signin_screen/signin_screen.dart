import 'package:ctse_assignment01/src/constants/colors/colors.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_button/custom_button.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_headline_text/custom_headline_text.dart';
import 'package:ctse_assignment01/src/screens/auth_screen/forgotpassword_screen/frogotpassword_screen.dart';
import 'package:ctse_assignment01/src/screens/auth_screen/signup_screen/user_role_select/user_role_select.dart';
import 'package:ctse_assignment01/src/screens/org_screens/org_edufeed_screen/org_edufeed_screen.dart';
import 'package:ctse_assignment01/src/screens/user_screens/home_screen/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/images/images.dart';
import '../../../constants/text/text.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../utils/shared_preferences/shared_preferences.dart';
import '../../../utils/snack_bar/snack_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    AppSharedPreferences.setonBoardingState(false);
  }

  var IsPasswordVisible = true;
  final Email = TextEditingController();
  final Password = TextEditingController();
  final SignInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    Email.dispose();
    Password.dispose();
  }

  Widget build(BuildContext context) {
    UserSignIn() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: Email.text, password: Password.text);

        FirebaseAuth.instance.currentUser?.reload();
        Navigator.of(context).pop();
        if(userController.getUser.userRole != null){
          if(userController.getUser.userRole == 'org'){
            Get.off(()=>OrgEduFeed());
          }else{
            Get.off(()=>HomeScreen());
          }
        }

        CustomSnackBars.showSuccessSnackBar("Successfully Sign In");
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        CustomSnackBars.showErrorSnackBar(e.message);
      }
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Form(
                    key: SignInFormKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image(image: AssetImage(tLogo)),
                          radius: 45.r,
                        ),
                        SizedBox(height: 20.h),
                        CustomHeadlineText(
                          text: "Edu Share",
                          textColor: tPrimaryColor,
                          textSize: 32.sp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          tSignInScreenText,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 60.h),
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter  Email";
                              } else if (!EmailValidator.validate(value)) {
                                return "Please Enter Valid Email";
                              } else {
                                return null;
                              }
                            },
                            controller: Email,
                            decoration: InputDecoration(labelText: 'Email')),
                        SizedBox(height: 34.h),
                        PasswordTexInput(
                            IsPasswordVisible,
                            'Password',
                            Password,
                            () => setState(() {
                                  IsPasswordVisible = !IsPasswordVisible;
                                }), (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        }),
                        SizedBox(height: 60.h),
                        CustomButton(
                            BtnText: "Sign In",
                            onPressed: () {
                              final isSignInFormValid =
                                  SignInFormKey.currentState!.validate();
                              if (isSignInFormValid) {
                                UserSignIn();
                              }
                            }),
                        SizedBox(height: 30.h),
                        TextButton(
                          onPressed: () {

                           Get.off(()=>ForgetPassword());
                          },

                          child: Text("Forgot Password ?",
                              style: TextStyle(fontSize: 14.sp)),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                Size.fromHeight(40.h)),
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account yet?"),
                            TextButton(
                                onPressed: () => {
                                      Get.to(UserRoleSelect(),
                                          transition:
                                              Transition.rightToLeftWithFade)
                                    },
                                child: Text("Create an account",
                                    style: TextStyle(fontSize: 14.sp))),
                          ],
                        )
                      ],
                    )),
              )),
        ));
  }

  Widget PasswordTexInput(
      bool IsPasswordVisible,
      String label,
      TextEditingController controller,
      VoidCallback onPressed,
      String? Function(String?) validateFunction) {
        
    return TextFormField(

        obscureText: IsPasswordVisible,
        validator: validateFunction,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon: IsPasswordVisible
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            )));
  }
}
