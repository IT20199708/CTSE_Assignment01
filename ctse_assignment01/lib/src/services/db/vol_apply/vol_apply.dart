
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/vol_apply_model/vol_apply_model.dart';

class VolApplyDb{

  static final CollectionReference collectionRef = FirebaseFirestore.instance.collection('VolunteerResponse');
  static CollectionReference<Map<String, dynamic>> _eduPostCollection = FirebaseFirestore.instance.collection('VolunteerResponse');


  static List<VolApplyModel> _eduPostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return VolApplyModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


  static Stream<List<VolApplyModel?>> get eduPosts{
    final Query filtered = _eduPostCollection.where('userId',isEqualTo:FirebaseAuth.instance.currentUser?.uid).orderBy('createdAt',descending: true);
    return filtered.snapshots().map(_eduPostListFromSnapshot);
  }

  static Future<void> createPost({ required VolApplyModel model}) async {
    try {
      final doc = model.toJSON();
      await collectionRef.add(doc);
    }
    catch (err) {
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

  static Future<bool> chekAlreadyApply({ required String id}) async{
    try{
      final Query query = FirebaseFirestore.instance.collection('VolunteerResponse').where('userId',isEqualTo:id);
      var data  = await query.get();
      if(data.docs.isNotEmpty){
        return true;
      }
      return false;
    }catch(err){
      rethrow;
    }
  }
}
