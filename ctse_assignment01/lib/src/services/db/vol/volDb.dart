
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../models/vol_post_model/vol_post_model.dart';

class VolDb{
  static final CollectionReference collectionRef = FirebaseFirestore.instance.collection('VolunteerPost');

  static final CollectionReference<Map<String, dynamic>> volPostCollection = FirebaseFirestore.instance.collection('VolunteerPost');
  static final   userController = Get.find<UserController>();

  static List<VolPostModel> _volPostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return VolPostModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


  static Stream<List<VolPostModel?>> get eduPosts{
    final Query filtered = volPostCollection.where('createdBy',isEqualTo:FirebaseAuth.instance.currentUser?.uid);
    return filtered.snapshots().map(_volPostListFromSnapshot);
  }


  static Stream<List<VolPostModel?>> get eduPostsForUser{
    final Query filtered = volPostCollection.where('interest',arrayContainsAny:userController.getUser.offeringAreas).orderBy('createdAt',descending: true);
    return filtered.snapshots().map(_volPostListFromSnapshot);
  }
  static Stream<List<VolPostModel?>> get eduPostsForHome{
    final Query filtered = volPostCollection.where('interest',arrayContainsAny:userController.getUser.offeringAreas).orderBy('createdAt',descending: true).limit(5);
    return filtered.snapshots().map(_volPostListFromSnapshot);
  }


  static Future<void> createPost({ required VolPostModel model}) async {
    try {
      final doc = model.toJSON();
      await collectionRef.add(doc);
    }
    catch (err) {
      rethrow;
    }
  }
  static Future<void> updatePost({ required VolPostModel model,required String id}) async {
    try {
      final doc = model.toJSON();
      print(id);
      print(doc);
      await collectionRef.doc(id).update(doc);
    }
    catch (err) {
      print(err);
      rethrow;
    }
  }
  static Future<void> deletePost({ required String id}) async {
    try{
      await collectionRef.doc(id).delete();
    }catch(err){
      rethrow;
    }
  }
}
