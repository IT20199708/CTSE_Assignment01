import 'package:ctse_assignment01/src/custom_widget/custom_loadingBtn/custom_loadingBtn.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../models/vol_apply_model/vol_apply_model.dart';
import '../../models/vol_post_model/vol_post_model.dart';
import '../../services/db/vol_apply/vol_apply.dart';
import '../../utils/snack_bar/snack_bar.dart';

class VolApplyForm extends StatefulWidget {
  final String? id;
  final VolPostModel? updateModel;
  VolApplyForm({Key? key, this.id, this.updateModel}) : super(key: key);

  @override
  State<VolApplyForm> createState() => _VolApplyFormState();
}

class _VolApplyFormState extends State<VolApplyForm> {
  final userController = Get.find<UserController>();
  bool isLoading = false;
  String?  _educationLevel ='UnderGraduate';
  final contactEmail = TextEditingController();
  final phoneNo = TextEditingController();
  final name = TextEditingController();
  final salary = TextEditingController();
  final address = TextEditingController();
  final aboutYou = TextEditingController();
  final EduApplyFormKey = GlobalKey<FormState>();
  final _EducationList = ['G.E.C O/L','G.E.C A/L','Diploma','UnderGraduate','Graduate','Master Degree'];
  var valid = true;

  Future submitForm() async {
    setState(() {
      isLoading = true;
    });
    final isAccountFormValid = EduApplyFormKey.currentState!.validate();
    valid = isAccountFormValid;
    if(valid){
      VolApplyModel model = new VolApplyModel(postTitle:widget.updateModel!.title,contactEmail:contactEmail.text.trim() ,educationLevel:_educationLevel,name:name.text.trim() ,phoneNo:phoneNo.text.trim() ,createdAt:DateTime.now() ,userId:FirebaseAuth.instance.currentUser?.uid, address: address.text, expectedSalary: double.parse(salary.text), aboutYou: aboutYou.text);
      try{
        var isAlreadyApplied = await VolApplyDb.chekAlreadyApply(id:FirebaseAuth.instance.currentUser!.uid);
        if(!isAlreadyApplied){
          await VolApplyDb.createPost(model:model);
          CustomSnackBars.showSuccessSnackBar('Apply for post successfully');
          Get.back();
        }else{
          CustomSnackBars.showWarningSnackBar('You already applied for this post');
          Get.back();
        }

      }on FirebaseException catch(e){
        CustomSnackBars.showErrorSnackBar(e.message);
      }
    } else{
      setState(() {
        isLoading = false;
      });
    }

  }


  @override
  void dispose() {
    super.dispose();
    contactEmail.dispose();
    phoneNo.dispose();
    name.dispose();
    salary.dispose();
    address.dispose();
    aboutYou.dispose();
  }

  @override
  void initState() {
    super.initState();
    contactEmail.text =userController.getUser.Email!;
    phoneNo.text = userController.getUser.ContactNo!;
    name.text = userController.getUser.firstName!+' '+ userController.getUser.lastName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Apply for offer'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding:EdgeInsets.all(10),
              child: Form(
                  key:EduApplyFormKey,
                  child: Column(
                    children: [

                      TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter  full name";
                            }  else {
                              return null;
                            }
                          },
                          controller: name,
                          decoration: InputDecoration(labelText: 'Full name')),//Name
                      DropdownButtonFormField(
                          validator: (value){
                            if(_educationLevel!.isEmpty) {
                              return "Please select education level";
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(labelText: 'Select Education Level'),
                          value:_educationLevel,
                          items: _EducationList.map((e)=>DropdownMenuItem(child: Text(e),value:e,)).toList(),
                          onChanged: (val){
                            setState((){
                              _educationLevel = val as String;
                            });
                          }),
                      TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter  Contact No";
                            } else if (value.length != 10) {
                              return "Please Enter Valid Contact No";
                            } else {
                              return null;
                            }
                          },
                          controller: phoneNo,
                          decoration: InputDecoration(labelText: 'Contact No')),//contact No
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Contact Email";
                            } else if (!EmailValidator.validate(value)) {
                              return "Please Enter Valid Contact Email";
                            } else {
                              return null;
                            }
                          },
                          controller: contactEmail,
                          decoration: InputDecoration(labelText: 'Contact Email')),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Expected Salary";
                            }else {
                              return null;
                            }
                          },
                          controller: salary,
                          decoration: InputDecoration(labelText: 'Expected Salary')),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter  Your Address";
                            } else {
                              return null;
                            }
                          },
                          controller: address,
                          decoration: InputDecoration(labelText: 'Address')),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter  About You";
                            } else {
                              return null;
                            }
                          },
                          controller: aboutYou,
                          decoration: InputDecoration(labelText: 'About You')),
                      //contactEmail
                    SizedBox(height: 20.h),
                      CustomLoadingButton(onPressed: submitForm, btnText: 'Apply',isLoading: isLoading,)
                    ],
                  )
              ),
            ),
          ),
        ));
  }
}
