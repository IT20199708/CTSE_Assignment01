
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/edu_apply_model/edu_apply_model.dart';

class EduApplyDb{

  static final CollectionReference collectionRef = FirebaseFirestore.instance.collection('EducationalResponse');
  static CollectionReference<Map<String, dynamic>> _eduPostCollection = FirebaseFirestore.instance.collection('EducationalResponse');


  static List<EduApplyModel> _eduPostListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((DocumentSnapshot document){
      return EduApplyModel.fromJson(document.data() as Map<String, dynamic>,document.id);
    }).toList();
  }


  static Stream<List<EduApplyModel?>> get eduPosts{
    final Query filtered = _eduPostCollection.where('userId',isEqualTo:FirebaseAuth.instance.currentUser?.uid).orderBy('createdAt',descending: true);
    return filtered.snapshots().map(_eduPostListFromSnapshot);
  }

  static Future<void> createPost({ required EduApplyModel model}) async {
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
      final Query query = FirebaseFirestore.instance.collection('EducationalResponse').where('userId',isEqualTo:id);
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
