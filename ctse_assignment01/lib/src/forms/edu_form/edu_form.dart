import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_loadingBtn/custom_loadingBtn.dart';
import 'package:ctse_assignment01/src/models/edu_post_model/edu_post_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../constants/colors/colors.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../custom_widget/custom_uploadImage/custom_uploadImage.dart';
import '../../models/interestArea_model/InterestAreaModel.dart';
import '../../screens/org_screens/org_edufeed_screen/org_edufeed_screen.dart';
import '../../services/db/edu/eduDb.dart';
import '../../utils/snack_bar/snack_bar.dart';

class EduForm extends StatefulWidget {
  final String? id;
  final EduPostModel? updateModel;
  EduForm({Key? key, this.id, this.updateModel}) : super(key: key);

  @override
  State<EduForm> createState() => _EduFormState();
}

class _EduFormState extends State<EduForm> {
  final userController = Get.find<UserController>();
  var targetAreas = [];
  bool isLoading = false;
  bool isUpdating = false;
  String?  _educationLevel ='UnderGraduate';
  String? _courseDuration = '3 Months';
  File? _image;
  final contactEmail = TextEditingController();
  final courseFee = TextEditingController();
  final phoneNo = TextEditingController();
  final title = TextEditingController();
  final details = TextEditingController();
  final closingDate = TextEditingController();
  final EduFormKey = GlobalKey<FormState>();
  final _EducationList = ['G.E.C O/L','G.E.C A/L','Diploma','UnderGraduate','Graduate','Master Degree'];
  final _CourseDurationList = ['3 Months','6 Months','1 Year','3 Year','4 Year'];
  var valid = true;
  Future<List<InterestAreaModel>> GetInterestAres() async{
    List<InterestAreaModel> Areas= [];
    CollectionReference interestAreas = FirebaseFirestore.instance.collection('interestAreas');
    QuerySnapshot querySnapshot = await interestAreas.get();

    if(querySnapshot.docs.isEmpty){
      Areas.add(new InterestAreaModel("No Data","No Data"));
      return Areas;
    }
    for(var doc in querySnapshot.docs){
      InterestAreaModel area = new InterestAreaModel(doc['name'],doc['description']);
      Areas.add(area);
    }
    return Areas;
  }

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

  Future<String> UploadImage() async {
    String filename = basename(_image!.path);
    String  path = 'eduPostImages/${filename}';
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
  
  Future submitForm() async {
    setState(() {
      isLoading = true;
    });

    final isAccountFormValid = EduFormKey.currentState!.validate();
    valid = isAccountFormValid;
    print(isAccountFormValid);
   if(isAccountFormValid){
     String urlUpload ='https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f';
     if(_image != null){
       urlUpload = await UploadImage();
     }

     EduPostModel model = new EduPostModel(userAvatar: userController.getUser.imgUrl,courseFee: double.parse(courseFee.text) ,thumbnailUrl: urlUpload, closingDate: closingDate.text.trim(), contactEmail: contactEmail.text.trim(), courseDuration: _courseDuration, createdAt: DateTime.now(), createdBy: FirebaseAuth.instance.currentUser?.uid, details: details.text, educationLevel: _educationLevel, interest: targetAreas, phoneNo: phoneNo.text.trim(), searchTag: title.text.toLowerCase().trim(), title: title.text.trim());
       try{
         await EduDb.createPost(model:model);
         CustomSnackBars.showSuccessSnackBar('Post successfully created');
         Get.off(()=>OrgEduFeed());
       }on FirebaseException catch(e){
         CustomSnackBars.showErrorSnackBar(e.message);
       }

   }else{
     setState(() {
       isLoading = false;
     });
   }

  }

  Future updateForm() async {
    setState(() {
      isLoading = true;
    });

    final isAccountFormValid = EduFormKey.currentState!.validate();
    valid = isAccountFormValid;
    print(isAccountFormValid);
    if(isAccountFormValid){
      String urlUpload ='';
      if(_image != null){
        urlUpload = await UploadImage();
      }

      EduPostModel model = new EduPostModel(userAvatar:userController.getUser.imgUrl,createdAt: widget.updateModel!.createdAt!,courseFee: double.parse(courseFee.text) ,thumbnailUrl:urlUpload.length != 0 ? urlUpload : widget.updateModel!.thumbnailUrl!, closingDate: closingDate.text.trim(), contactEmail: contactEmail.text.trim(), courseDuration: _courseDuration,  createdBy: FirebaseAuth.instance.currentUser?.uid, details: details.text, educationLevel: _educationLevel, interest: targetAreas, phoneNo: phoneNo.text.trim(), searchTag: title.text.toLowerCase().trim(), title: title.text.trim());
      try{
        await EduDb.updatePost(model:model,id: widget.updateModel!.id!);
        CustomSnackBars.showSuccessSnackBar('Post successfully updated');
        Get.off(()=>OrgEduFeed());
      }on FirebaseException catch(e){
        CustomSnackBars.showErrorSnackBar(e.message);
      }

    }else{
      setState(() {
        isLoading = false;
      });
    }

  }
  @override
  void dispose() {
    super.dispose();
    contactEmail.dispose();
    courseFee.dispose();
    phoneNo.dispose();
    title.dispose();
    details.dispose();
  }

  @override
  void initState() {
    super.initState();

    if(widget.updateModel != null){
      isUpdating =true;
      targetAreas = widget.updateModel!.interest!;
      _educationLevel = widget.updateModel!.educationLevel!;
      _courseDuration = widget.updateModel!.courseDuration!;
      contactEmail.text = widget.updateModel!.contactEmail!;
      courseFee.text = widget.updateModel!.courseFee!.toString();
      phoneNo.text = widget.updateModel!.phoneNo!;
      title.text = widget.updateModel!.title!;
      details.text = widget.updateModel!.details!;
      closingDate.text = widget.updateModel!.closingDate!;


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Post Education Offer'),
        centerTitle: true,
      ),
        body: SafeArea(
          child: Container(
            padding:EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key:EduFormKey,
                  child: Column(
                children: [

                  TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter  Post Title";
                        }  else {
                          return null;
                        }
                      },
                      controller: title,
                      decoration: InputDecoration(labelText: 'Post Title')),//Post Title
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,

                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter  Post Details";
                        } else {
                          return null;
                        }
                      },
                      controller: details,
                      decoration: InputDecoration(labelText: 'Post Details')), //Post Details
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
                  Container(
                    height: 400.h,
                    child: FutureBuilder(
                        future:GetInterestAres(),
                        builder: (context,AsyncSnapshot<List<InterestAreaModel>> snapshot){
                          if(snapshot.hasData){
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                   children: [
                                     !valid && targetAreas.length == 0 ? Text('Please select one or more target areas',style:TextStyle(color: Colors.red) ,): Text("Select Target Areas",style: Theme.of(context).textTheme.subtitle1,),
                                     Wrap(
                                       runSpacing: 10,
                                       spacing: 10,
                                       children:getChipWidget(snapshot.data!) ,
                                     ),
                                   ],
                                  ),
                                ),

                            );
                          }

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),//Target Area
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
                  DropdownButtonFormField(
                      value:_courseDuration,
                      validator: (value){
                        if(_courseDuration!.isEmpty) {
                          return "Please select education level";
                        }else{
                          return null;
                        }
                      },

                      decoration: InputDecoration(labelText: 'Select Course Duration'),
                      items: _CourseDurationList.map((e)=>DropdownMenuItem(child: Text(e),value:e,)).toList(),
                      onChanged: (val){
                        setState((){
                          _courseDuration = val as String;
                        });
                      }),//course duration
                  TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Course Fee";
                        }else if(!value.isNumericOnly){
                          return 'Enter valid course fee';
                        }else {
                          return null;
                        }
                      },
                      controller: courseFee,
                      decoration: InputDecoration(labelText: 'Course Fee')),//Course Fee
                  TextFormField(
                      keyboardType: TextInputType.datetime,
                      onTap: ()async{
                        DateTime? pickeDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100)
                        );
                        if(pickeDate != null){
                          setState(() {
                            closingDate.text = DateFormat('yyyy-MM-dd').format(pickeDate);
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter  Closing Date";
                        }else {
                          return null;
                        }
                      },
                      controller: closingDate,
                      decoration: InputDecoration(labelText: 'Closing Date',icon: Icon(Icons.calendar_month_rounded))),//closing date
                  SizedBox(height: 20.h),
                 isUpdating ?CustomUploadImage(onPressed: getImage,imageFile: _image,isUpdating:isUpdating,url: widget.updateModel!.thumbnailUrl!): CustomUploadImage(onPressed: getImage,imageFile: _image),

                  SizedBox(height: 20.h),
                  isUpdating ? CustomLoadingButton(onPressed: updateForm, btnText: 'Update post',isLoading: isLoading,) : CustomLoadingButton(onPressed: submitForm, btnText: 'Add post',isLoading: isLoading,)
                ],
              )
              ),
            ),
          ),
        ));
  }

  List<Widget> getChipWidget(List<InterestAreaModel> list){
    return list.map((e) => FilterChip(label: Text(e.name), onSelected: (value) {
      setState((){
        if(value){
          targetAreas.add(e.name);
          print(targetAreas);
        }else{
          targetAreas.removeWhere((element) => element == e.name);
        }
      });
    }, selected: targetAreas.contains(e.name),
      checkmarkColor: tPrimaryColor,
      selectedColor: tPrimaryColor.withOpacity(0.25),)).toList();
  }
}
