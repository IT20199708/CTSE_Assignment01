import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../models/don_post_model/don_post_model.dart';

class DonDb {
  static CollectionReference<Map<String, dynamic>> donPostCollection =
      FirebaseFirestore.instance.collection('DonationPost');
  static final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('DonationPost');
  static final userController = Get.find<UserController>();

  static List<DonPostModel> _donPostListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot document) {
      return DonPostModel.fromJson(
          document.data() as Map<String, dynamic>, document.id);
    }).toList();
  }

  static Stream<List<DonPostModel?>> get eduPosts {
    final Query filtered = donPostCollection.where('createdBy',
        isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    return filtered.snapshots().map(_donPostListFromSnapshot);
  }

  static Stream<List<DonPostModel?>> get eduPostsForUser {
    final Query filtered = donPostCollection
        .where('interest',
            arrayContainsAny: userController.getUser.offeringAreas)
        .orderBy('createdAt', descending: true);
    return filtered.snapshots().map(_donPostListFromSnapshot);
  }

  static Stream<List<DonPostModel?>> get eduPostsForHome {
    final Query filtered = donPostCollection
        .where('interest',
            arrayContainsAny: userController.getUser.offeringAreas)
        .orderBy('createdAt', descending: true)
        .limit(5);
    return filtered.snapshots().map(_donPostListFromSnapshot);
  }

  static Future<void> createPost({required DonPostModel model}) async {
    try {
      final doc = model.toJSON();
      await collectionRef.add(doc);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> updatePost(
      {required DonPostModel model, required String id}) async {
    try {
      final doc = model.toJSON();
      print(id);
      print(doc);
      await collectionRef.doc(id).update(doc);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  static Future<void> deletePost({required String id}) async {
    try {
      await collectionRef.doc(id).delete();
    } catch (err) {
      rethrow;
    }
  }
}
