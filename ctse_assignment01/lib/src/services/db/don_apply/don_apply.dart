
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/don_apply_model/don_apply_model.dart';
import '../../../models/vol_apply_model/vol_apply_model.dart';

class DonApplyDb{

  static final CollectionReference collectionRef = FirebaseFirestore.instance.collection('DonationResponse');
  static CollectionReference<Map<String, dynamic>> _eduPostCollection = FirebaseFirestore.instance.collection('DonationResponse');


  static List<DonApplyModel> _eduPostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return DonApplyModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


  static Stream<List<DonApplyModel?>> get eduPosts{
    final Query filtered = _eduPostCollection.where('userId',isEqualTo:FirebaseAuth.instance.currentUser?.uid).orderBy('createdAt',descending: true);
    return filtered.snapshots().map(_eduPostListFromSnapshot);
  }

  static Future<void> createPost({ required DonApplyModel model}) async {
    try {
      final doc = model.toJSON();
      await collectionRef.add(doc);
    }
    catch (err) {
      rethrow;
    }
  }

}
