
import 'package:ctse_assignment01/src/screens/auth_screen/signin_screen/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller/user_controller.dart';
import '../../screens/user_screens/home_screen/home_screen.dart';
import '../../screens/user_screens/user_don_feed/user_don_feed.dart';
import '../../screens/user_screens/user_edu_feed/user_edu_feed.dart';
import '../../screens/user_screens/user_profile/user_profile.dart';
import '../../screens/user_screens/user_vol_feed/user_vol_feed.dart';
import '../../utils/snack_bar/snack_bar.dart';

class CustomUserDrawer extends StatelessWidget {
  CustomUserDrawer({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
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

    );
  }


  Widget DrawerHeader(BuildContext context) {
    return Container(
      color: Colors.blue,
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
                          userController.getUser.imgUrl ?? 'https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/user%20avatar.png?alt=media&token=98bc263d-1414-4c39-8bab-1eeb8013637f')
                  )
              )
          ),
          Text(userController.getUser.firstName ?? 'Example User',
            style: TextStyle(color: Colors.white, fontSize: 20),),
          Text(userController.getUser.Email ?? 'info@gmail.com',
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
            leading:const Icon(Icons.home),
            title: const Text('Home',style: TextStyle(fontSize: 16)),
            onTap:(){
              Navigator.pop(context);
              Get.off(()=>HomeScreen());
            } ,
          ),
          ListTile(
            selectedColor: CupertinoColors.opaqueSeparator,
            leading:const Icon(Icons.menu_book),
            title: const Text('Education Offers',style: TextStyle(fontSize: 16)),
            onTap:(){
              Navigator.pop(context);
              Get.off(()=>UserEduFeed());
            } ,
          ),
          ListTile(
            leading:const Icon(Icons.accessibility),
            title: const Text('Volunteer Offers',style: TextStyle(fontSize: 16)),
            onTap:(){
              Navigator.pop(context);
              Get.off(()=>UserVolFeed());
            } ,
          ),
          ListTile(
            leading:const Icon(Icons.monetization_on),
            title: const Text('Donation Offers',style: TextStyle(fontSize: 16)),
            onTap:(){
              Navigator.pop(context);
              Get.off(()=>UserDonFeed());
            } ,
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading:const Icon(Icons.account_box),
            title: const Text('Profile',style: TextStyle(fontSize: 16)),
            onTap:(){
              Navigator.pop(context);
              Get.to(()=>UserProfile());
            } ,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text('Logout',style: TextStyle(fontSize: 16)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.off(()=>SignIn());
              CustomSnackBars.showSuccessSnackBar('Successfully signed out');
            },
          ),
        ],
      ),

    );
  }




}