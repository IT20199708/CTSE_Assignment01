import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/models/user_model/User.dart';
import 'package:get/get.dart';



class UserController extends GetxController{
  // final user= OrgUser(OrganizationName: OrganizationName, OrganizationShortName: OrganizationShortName, ContactNo: ContactNo, Email: Email, Address: Address)

     late Rx<UserModel> currentUser = UserModel().obs;

     //return user instance
     UserModel get getUser => currentUser.value;

     //set new instance
     set user(UserModel value) => this.currentUser.value = value;

     void clear(){
       currentUser.value = UserModel();
     }




  Future<UserModel> checkUserType(String id) async {
     CollectionReference<Map<String, dynamic>> user = FirebaseFirestore.instance.collection('user');
     var userDoc = await user.doc(id).get();
      UserModel User  = UserModel.fromJson(userDoc.data()!);
      return User;
   }
   
}