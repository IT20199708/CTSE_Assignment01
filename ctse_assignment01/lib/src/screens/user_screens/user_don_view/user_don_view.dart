import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_big_text/custom_big_text.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_expandable_text/custom_expandable_text.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_small_text/custom_small_text.dart';
import 'package:ctse_assignment01/src/models/don_post_model/don_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../forms/don_apply_form/don_apply_form.dart';


class UserDonView extends StatelessWidget {
  final DonPostModel model;

  UserDonView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: CachedNetworkImage(
                  imageUrl: model.thumbnailUrl != ''
                      ? model.thumbnailUrl!
                      : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
                  imageBuilder: (context, imageProvider) => Container(
                      height: 350.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover))),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned(
                  top: 20.h,
                  left: 10,
                  right: 0,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.white,child: IconButton( onPressed: () => Get.back(), icon:Icon(Icons.arrow_back,color:Colors.black),))
                    ],
                  )
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 250.h,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 20.h),
                        BigText(text:model.title!,color: Colors.grey[800]),
                        SizedBox(height: 10.h),
                        SmallText(text:"Posted "+timeago.format(model.createdAt!),color: Colors.grey[500]),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              IconCard(Icons.email,'Contact Mail',model.contactEmail!),
                              IconCard(Icons.phone,'Contact No',model.phoneNo!),
                            ],
                          ),
                        ),

                        Divider(color: Colors.black),
                        BigText(text: "Description",color: Colors.grey[600],),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SingleChildScrollView(
                              child: CustomExpandableText(text: model.details!)),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => DonApplyForm(updateModel:model,));
                          },
                          child: Text('Donate'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(40),
                              textStyle: TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
                  )
              )

            ],
          )),
    );
  }
}

List<Widget> getChipWidget(List<dynamic> chipList) {
  return chipList
      .map((chip) => Chip(
    label: Text(chip),

    backgroundColor: Colors.blue,
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Colors.white,
    ),
    avatar: CircleAvatar(
        child: Icon(Icons.tag, color: Colors.white.withOpacity(0.8)),
        backgroundColor: Colors.transparent),
  ))
      .toList();
}

Widget IconCard(IconData icon,String title,String text){
  return Card(
    elevation: 2,
    margin: EdgeInsets.only(right:20,top:20,bottom:20),
    child:Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,color: Colors.black45),
          SizedBox(height:10),
          BigText(text: title,color: Colors.grey[700],size: 18),
          SizedBox(height:10),
          SmallText(text: text,color: Colors.blue[700]),
        ],
      ),
    ) ,
  );
}
