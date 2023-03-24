
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/models/edu_post_model/edu_post_model.dart';
import 'package:get/get.dart';


import '../../../controllers/user_controller/user_controller.dart';

class EduDb{

  static final CollectionReference collectionRef = FirebaseFirestore.instance.collection('EducationalPost');
  static CollectionReference<Map<String, dynamic>> _eduPostCollection = FirebaseFirestore.instance.collection('EducationalPost');
  static final   userController = Get.find<UserController>();

  static List<EduPostModel> _eduPostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return EduPostModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


  static Stream<List<EduPostModel?>> get eduPosts{
    final Query filtered = _eduPostCollection.where('interest',arrayContainsAny:userController.getUser.offeringAreas).orderBy('createdAt',descending: true);
    return filtered.snapshots().map(_eduPostListFromSnapshot);
  }



  static Stream<List<EduPostModel?>> get eduPostsForHome{
    final Query filtered = _eduPostCollection.where('interest',arrayContainsAny:userController.getUser.offeringAreas).orderBy('createdAt',descending: true).limit(5);
    return filtered.snapshots().map(_eduPostListFromSnapshot);
  }


  static Future<void> createPost({ required EduPostModel model}) async {
    try {
      final doc = model.toJSON();
      await collectionRef.add(doc);
    }
    catch (err) {
      rethrow;
    }
  }

  static Future<void> updatePost({ required EduPostModel model,required String id}) async {
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
