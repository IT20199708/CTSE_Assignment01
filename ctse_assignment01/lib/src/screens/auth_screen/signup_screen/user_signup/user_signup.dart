import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/constants/colors/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../../custom_widget/custom_headline_text/custom_headline_text.dart';
import '../../../../custom_widget/custom_profileImage/custom_profileImage.dart';
import '../../../../models/user_model/User.dart';
import '../../../../utils/snack_bar/snack_bar.dart';
import '../../../startup_screen/intrest_area_screen/intrest_area_screen.dart';


class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  int currentStep = 0;
  final AccountFormKey = GlobalKey<FormState>();
  final BasicDetailFormKey = GlobalKey<FormState>();

  final Email = TextEditingController();
  final Password = TextEditingController();
   final ContactNo = TextEditingController();
  final ConfirmPassword = TextEditingController();
  final OrganizationShortName = TextEditingController();
  final OrganizationName = TextEditingController();
  final Address = TextEditingController();
 
  String url = '';
  var IsPasswordVisible = true;
  File? _image;

  Future getImage() async {

    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
        print('Image Path $_image');
      });
    } on PlatformException catch (e) {
      print('Failed to pick image:$e');
    }
  }

  @override
  void dispose() {

    super.dispose();
    Email.dispose();
    Password.dispose();
    ConfirmPassword.dispose();
    OrganizationName.dispose();
    OrganizationShortName.dispose();
    Address.dispose();
    ContactNo.dispose();
  }
  @override
  Widget build(BuildContext context) {


    Future<String> UploadImage() async {
      String filename = basename(_image!.path);
      String  path = 'userProfileImages/${filename}';
      try{

        final ref = FirebaseStorage.instance.ref().child(path);
        var uploadTask = ref.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() => {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        return urlDownload;
      }
      on FirebaseException catch (e) {
        CustomSnackBars.showErrorSnackBar(e.message);
      }
      return '';
    }

    Future CreateUser(String? id) async {
      try{
        final docRefUser = FirebaseFirestore.instance.collection("user").doc(id);
        final user = new UserModel(firstName:OrganizationName.text.trim(), lastName: OrganizationShortName.text.trim(), ContactNo:ContactNo.text.trim(), Email:Email.text.trim(), Address: Address.text.trim(),imgUrl: url);
        final jsonUser = user.toJSON();
        await docRefUser.set(jsonUser);
      }  on FirebaseException catch (e) {
        CustomSnackBars.showErrorSnackBar(e.message);
      }
    }

    //Firebase User Sign Up

    Future SignUpUser () async{
      showDialog(context: context, barrierDismissible: false, builder: (context){
        return Center(child: CircularProgressIndicator());
      });
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Email.text.trim(),
          password: Password.text.trim(),
        );

        //Upload image

        if(_image != null){
          url = await UploadImage();
        }
        await CreateUser(credential.user?.uid);
        Navigator.of(context).pop();
        Get.off(()=>InterestArea(userRole: 'user'));
        CustomSnackBars.showSuccessSnackBar('You are successfully signed up');

      } 

      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          CustomSnackBars.showErrorSnackBar('weak-password');
          Navigator.of(context).pop();
        } else if (e.code == 'email-already-in-use') {
          CustomSnackBars.showErrorSnackBar('The account already exists for that email pleae try again.');
          Navigator.of(context).pop();
        }else{
          CustomSnackBars.showErrorSnackBar(e.message);
          Navigator.of(context).pop();
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context)
              .copyWith(colorScheme: ColorScheme.light(primary: tPrimaryColor)),
          child: Stepper(
              currentStep: currentStep,
              elevation: 0,
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() => currentStep -= 1);
                }
              },
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                final isAccountFormValid =
                AccountFormKey.currentState!.validate();
                final isBasicFormValid =BasicDetailFormKey.currentState!.validate();
                if (isLastStep && isBasicFormValid) {
                  SignUpUser();
                } else {
                  if (currentStep == 0 && isAccountFormValid) {
                    setState(() => currentStep += 1);
                  }
                }
              },
              controlsBuilder:
                  (BuildContext context, ControlsDetails controllers) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Row(children: <Widget>[
                        if (currentStep == 0)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controllers.onStepContinue,
                              child: const Text('NEXT'),
                            ),
                          ),
                      ]),
                      Column(children: [
                        Row(
                          children: [
                            if (currentStep == 1)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: controllers.onStepContinue,
                                  child: const Text('Complete Sign Up'),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            if (currentStep == 1)
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: controllers.onStepCancel,
                                  child: const Text('Back'),
                                ),
                              ),
                          ],
                        ),
                      ])
                    ],
                  ),
                );
              },
              type: StepperType.horizontal,
              steps: getSteps()),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
        title: Text("SetUp Account"),
        isActive: currentStep >= 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Form(
          key: AccountFormKey,
          child: Column(
            children: [
              CustomHeadlineText(
                  text: "Account Details",
                  textSize: 20.sp,
                  textColor: tPrimaryColor),
              SizedBox(height: 20.h),
              CustomProfileImage(
                  onPressed: getImage,
                  imagePath: _image == null
                      ? 'https://images.unsplash.com/photo-1665172653767-795eb690da50?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1887&q=80'
                      : '',
                  imageFile: _image != null ? _image : null,
                  isNetWorkImage: _image != null ? false : true),
              SizedBox(height: 20.h),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty)
                    {
                      return "Please Enter  Email";
                    }else if(!EmailValidator.validate(value)){
                      return "Please Enter Valid Email";
                    } else {
                      return null;
                    }
                  },
                  controller: Email,
                  decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 20.h),
              PasswordTexInput(
                  IsPasswordVisible,
                  'Password',
                  Password,
                      () => setState(() {
                    IsPasswordVisible = !IsPasswordVisible;
                  }),
                      (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Password";
                    }else if(value.length < 6){
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  }),
              SizedBox(height: 20.h),
              PasswordTexInput(IsPasswordVisible,'Confirm Password',ConfirmPassword, () => setState(() {
                IsPasswordVisible = !IsPasswordVisible;
              }),(value) {
                if (value!.isEmpty) {
                  return "Please Enter Confirm Password";
                }else if(value != Password.text){
                  return "Password and Confirm Password mismatch";
                } else {
                  return null;
                }
              } ),
              SizedBox(height: 20.h),
            ],
          ),
        )),
    Step(
        title: Text("Basic Details"),
        isActive: currentStep >= 1,
        content: Form(
          key: BasicDetailFormKey,
          child: Column(
            children: [
              TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: OrganizationName,
                  validator:(value){
                    if(value!.isEmpty) {
                      return "Please Enter First Name";
                    }else{
                      return null;
                    }
                  },
                  decoration:
                  InputDecoration(labelText: 'First Name')),
              SizedBox(height: 20.h),
              TextFormField(
                  controller: OrganizationShortName,
                  validator:(value){
                    if(value!.isEmpty) {
                      return "Please Enter Last  Name";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Last Name')),
              SizedBox(height: 20.h),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: ContactNo,
                  validator:(value){
                    if(value!.isEmpty) {
                      return "Please Enter Contact No";
                    }else if(value.length != 10){
                      return "Please Enter Valid Contact No";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Contact No')),
              SizedBox(height: 20.h),
              TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: Address,
                  validator:(value){
                    if(value!.isEmpty) {
                      return "Please Enter Address";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Address')),
            ],
          ),
        )),
    // Step(title: Text("Details3"),isActive: currentStep >= 2, content: Container()),
  ];

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
