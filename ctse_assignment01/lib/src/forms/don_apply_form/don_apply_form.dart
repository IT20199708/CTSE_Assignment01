import 'package:ctse_assignment01/src/custom_widget/custom_loadingBtn/custom_loadingBtn.dart';
import 'package:ctse_assignment01/src/models/don_apply_model/don_apply_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../models/don_post_model/don_post_model.dart';
import '../../services/db/don_apply/don_apply.dart';
import '../../utils/snack_bar/snack_bar.dart';

class DonApplyForm extends StatefulWidget {
  final String? id;
  final DonPostModel? updateModel;
  DonApplyForm({Key? key, this.id, this.updateModel}) : super(key: key);

  @override
  State<DonApplyForm> createState() => _DonApplyFormState();
}

class _DonApplyFormState extends State<DonApplyForm> {
  final userController = Get.find<UserController>();
  bool isLoading = false;

  final contactEmail = TextEditingController();
  final phoneNo = TextEditingController();
  final name = TextEditingController();
  final salary = TextEditingController();
  final address = TextEditingController();
  final aboutYou = TextEditingController();
  final EduApplyFormKey = GlobalKey<FormState>();

  var valid = true;

  Future submitForm() async {
    setState(() {
      isLoading = true;
    });
    final isAccountFormValid = EduApplyFormKey.currentState!.validate();
    valid = isAccountFormValid;
    if(valid){
      DonApplyModel model = new DonApplyModel(postTitle:widget.updateModel!.title,contactEmail:contactEmail.text.trim() ,name:name.text.trim() ,phoneNo:phoneNo.text.trim() ,createdAt:DateTime.now() ,userId:FirebaseAuth.instance.currentUser?.uid,message: '', cardNumber: null, cvv: '', expDate: '',donationAmount: double.parse(salary.text));
      try{
          await DonApplyDb.createPost(model:model);
          CustomSnackBars.showSuccessSnackBar('Donation complete successfully');
          Get.back();
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
          title: Text('Donate'),
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Donation Amount";
                            }else if(double.parse(value) <= 0){
                              return "Please enter donation amount greater than 0";
                            }else {
                              return null;
                            }
                          },
                          controller: salary,
                          decoration: InputDecoration(labelText: 'Donation Amount')),
                      SizedBox(height: 20.h),
                      CustomLoadingButton(onPressed: submitForm, btnText: 'Donate',isLoading: isLoading,)
                    ],
                  )
              ),
            ),
          ),
        ));
  }
}
