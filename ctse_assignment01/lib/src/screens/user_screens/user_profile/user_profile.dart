import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_big_text/custom_big_text.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_small_text/custom_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/user_controller/user_controller.dart';
import 'TabOnePage.dart';
import 'TabThreePage.dart';
import 'TabTwoPage.dart';
class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {
  final userController = Get.find<UserController>();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('User Profile'),
        leading:BackButton(
          color: Colors.white,
          onPressed: ()=>Get.back()
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
    margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
          imageUrl: userController.getUser.imgUrl != ''
          ? userController.getUser.imgUrl!
              : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
            imageBuilder: (context, imageProvider) =>Center(
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 50,
                      child: Image(image: imageProvider),
                    ),
                  SizedBox(height: 20.h),
                  BigText(text: userController.getUser.firstName! + userController.getUser.lastName!,color: Colors.grey[700]),
                  SizedBox(height: 10.h),
                  SmallText(text: userController.getUser.Email!,color: Colors.grey[600],size: 16,)
                ],
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
              //
              // BigText(text: "Education Level")
              // SmallText(text:userController.getUser. )
              SizedBox(height: 20.h),
              BigText(text: "Contact No", color: Colors.grey[700]),
              SizedBox(height: 10.h),
              SmallText(text:userController.getUser.ContactNo!,size: 16,color: Colors.black45),
              SizedBox(height: 20.h),
              BigText(text: "Address", color: Colors.grey[700]),
              SizedBox(height: 10.h),
              SmallText(text:userController.getUser.Address!,size: 16,color: Colors.black45),
              SizedBox(height: 20.h),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SmallText(text: 'Interest Areas',size: 16,color: Colors.grey[700]),
                      SizedBox(height: 20.h),
                      Wrap(
                        spacing: 5,
                        children: getChipWidget(userController.getUser.offeringAreas!),
                      )
                    ],
                  )
              ),
             Container(
               child: TabBar(
                   controller:_tabController,
                   labelColor: Colors.grey[800],
                   unselectedLabelColor: Colors.grey,
                   tabs: [
                   Tab(text:'Education',),
                   Tab(text:'Volunteer',),
                 ]
               ),
             ),
            Container(
              width: double.maxFinite,
              height: 300,
              child: TabBarView(
                  controller:_tabController ,
                  children: [
                    TabOnePage(),
                    TabTwoPage(),
                  ]),
            )
            ],
          ),
        ),
      ),
    );
  }


}

List<Widget> getChipWidget(List<dynamic> chipList){
  return chipList.map(
          (chip) => Chip(label: Text(chip),labelPadding: EdgeInsets.all(4),backgroundColor: Colors.blue,
        labelStyle: TextStyle(
          fontWeight:FontWeight.bold,
          fontSize: 11,
          color: Colors.white,
        ),
        avatar: CircleAvatar(
            child: Icon(Icons.tag,color:Colors.white.withOpacity(0.8)),
            backgroundColor: Colors.transparent
        ),
      )
  ).toList();
}



