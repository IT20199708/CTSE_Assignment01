import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/models/edu_apply_model/edu_apply_model.dart';
import 'package:ctse_assignment01/src/services/db/edu_apply/edu_apply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/snack_bar/snack_bar.dart';

class TabOnePage extends StatelessWidget {
  const TabOnePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EduApplyModel?>>(
      stream: EduApplyDb.eduPosts,
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          if(snapshot.data.length > 0) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child:
                        CustomCard(snapshot.data[index],context));
                });
          }else{
            return Center(child: Text('No Data to Show'));
          }
        } else {
          return Center(child: Text('No Data to Show'));
        }
      },
    );
  }
}


Widget CustomCard(EduApplyModel model,BuildContext context){
  return Card(
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
        Expanded(
          child: Text( model.postTitle!,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                    fontSize: 12,
                )
          ),
        ),
            IconButton(onPressed: (){
              _showBottomSheet(model.id!,context);
            }, icon:Icon(Icons.delete),)
          ],
        ),
      ),
    );
}

void _showBottomSheet(String id,BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return  Container(
          padding: EdgeInsets.all(20),
          height:180.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              Text('Are you sure to delete this post?'),

              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"))),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                          ),
                          onPressed: () async {
                            try{
                              await EduApplyDb.deletePost(id: id);
                              Navigator.of(context).pop();
                              CustomSnackBars.showSuccessSnackBar('Your response deleted successfully');
                            }on FirebaseException catch(e){
                              CustomSnackBars.showErrorSnackBar(e.message);
                            }

                          }, child: Text("Delete"))),
                ],
              )
            ],
          ),
        );

      });
}