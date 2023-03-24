import 'package:ctse_assignment01/src/custom_widget/custom_loadingBtn/custom_loadingBtn.dart';
import 'package:ctse_assignment01/src/models/edu_post_model/edu_post_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../models/edu_apply_model/edu_apply_model.dart';
import '../../services/db/edu_apply/edu_apply.dart';
import '../../utils/snack_bar/snack_bar.dart';

class EduApplyForm extends StatefulWidget {
  final String? id;
  final EduPostModel? updateModel;
  EduApplyForm({Key? key, this.id, this.updateModel}) : super(key: key);

  @override
  State<EduApplyForm> createState() => _EduApplyFormState();
}

class _EduApplyFormState extends State<EduApplyForm> {
  final userController = Get.find<UserController>();
  bool isLoading = false;
  String?  _educationLevel ='UnderGraduate';
  final contactEmail = TextEditingController();
  final phoneNo = TextEditingController();
  final name = TextEditingController();
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
      EduApplyModel model = new EduApplyModel(postTitle:widget.updateModel!.title,contactEmail:contactEmail.text.trim() ,educationLevel:_educationLevel,name:name.text.trim() ,phoneNo:phoneNo.text.trim() ,createdAt:DateTime.now() ,userId:FirebaseAuth.instance.currentUser?.uid);
      try{
        var isAlreadyApplied = await EduApplyDb.chekAlreadyApply(id:FirebaseAuth.instance.currentUser!.uid);
        if(!isAlreadyApplied){
          await EduApplyDb.createPost(model:model);
          CustomSnackBars.showSuccessSnackBar('Apply for post successfully!');
          Get.back();
        }else{
          CustomSnackBars.showWarningSnackBar('You already applied for this post!');
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
                              return "Please Enter  Full Name";
                            }  else {
                              return null;
                            }
                          },
                          controller: name,
                          decoration: InputDecoration(labelText: 'Full Name')),//Name
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
                          decoration: InputDecoration(labelText: 'Contact Email')),//contactEmail
                      Expanded(child:Container()),
                     CustomLoadingButton(onPressed: submitForm, btnText: 'Apply',isLoading: isLoading,)
                    ],
                  )
              ),
          ),
        ));
  }
}
