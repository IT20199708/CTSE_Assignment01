import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/models/edu_post_model/edu_post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';



class OrgController extends GetxController {
  CollectionReference<Map<String, dynamic>> eduPostCollection =
      FirebaseFirestore.instance.collection('EducationalPost');

  List<EduPostModel> _edupostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return EduPostModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


 Stream<List<EduPostModel?>> get eduPosts{
   final Query filtered = eduPostCollection.where('createdBy',isEqualTo:FirebaseAuth.instance.currentUser?.uid);

   return filtered.snapshots().map(_edupostListFromSnapshot);
 }

}
