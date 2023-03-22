
import 'package:ctse_assignment01/src/controllers/user_controller/user_controller.dart';
import 'package:ctse_assignment01/src/screens/org_screens/org_donfeed_screen/org_donfeed_screen.dart';
import 'package:ctse_assignment01/src/screens/org_screens/org_edufeed_screen/org_edufeed_screen.dart';
import 'package:ctse_assignment01/src/screens/org_screens/org_volfeed_screen/org_volfeed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../screens/auth_screen/signin_screen/signin_screen.dart';


class CustomDrawer extends StatelessWidget {

  CustomDrawer({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                DrawerHeader(context),
                DrawerList(context)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget DrawerHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 70.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'gs://ctse-assignment-c675f.appspot.com/common/avatar.png')
                  )
              )
          ),
          Text(userController.getUser.firstName!,
            style: TextStyle(color: Colors.white, fontSize: 20),),
          Text(userController.getUser.Email ??'info@gmail.com',
              style: TextStyle(color: Colors.grey[200], fontSize: 14))
        ],
      ),
    );
  }


  Widget DrawerList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
            children: [

              ListTile(
                selectedColor: CupertinoColors.opaqueSeparator,
                leading:const Icon(Icons.menu_book),
                title: const Text('Education Post',style: TextStyle(fontSize: 16)),
                onTap:(){
                  Navigator.pop(context);
                  Get.off(()=>OrgEduFeed());
                } ,
              ),
              ListTile(
                leading:const Icon(Icons.accessibility),
                title: const Text('Volunteer Post',style: TextStyle(fontSize: 16)),
                onTap:(){
                  Navigator.pop(context);
                  Get.off(()=>OrgVolFeed());
                } ,
              ),
              ListTile(
                leading:const Icon(Icons.monetization_on),
                title: const Text('Donation Post',style: TextStyle(fontSize: 16)),
                onTap:(){
                  Navigator.pop(context);
                  Get.off(()=>OrgDonFeed());
                } ,
              ),
              const Divider(color: Colors.black54,),

             ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    title: Text('Logout',style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Get.off(()=>SignIn());
                      FirebaseAuth.instance.signOut();
                    },
              ),
            ],
      ),

    );
  }




}