import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctse_assignment01/src/models/don_post_model/don_post_model.dart';
import 'package:ctse_assignment01/src/screens/user_screens/user_don_view/user_don_view.dart';
import 'package:ctse_assignment01/src/screens/user_screens/user_edu_feed/user_edu_feed.dart';
import 'package:ctse_assignment01/src/services/db/don/donDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller/user_controller.dart';
import '../../../custom_widget/custom_big_text/custom_big_text.dart';
import '../../../custom_widget/custom_small_text/custom_small_text.dart';
import '../../../custom_widget/custom_user_drawer/custom_user_drawer.dart';
import '../../../models/edu_post_model/edu_post_model.dart';
import '../../../models/vol_post_model/vol_post_model.dart';
import '../../../services/db/edu/eduDb.dart';
import '../../../services/db/vol/volDb.dart';
import '../user_don_feed/user_don_feed.dart';
import '../user_edu_view/user_edu_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../user_vol_feed/user_vol_feed.dart';
import '../user_vol_view/user_vol_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final   userController = Get.find<UserController>();
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

          appBar: AppBar(
            elevation: 0,
            title:Text("Explore"),
            centerTitle: true,
            iconTheme: IconThemeData(color:Colors.white),
          ),
          drawer:CustomUserDrawer(),
          body: Container(
              child:SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      height: 150.h,
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Hello!'+' '+userController.getUser.firstName!,style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 18
                                )),
                                SizedBox(width: 10.w),
                                Icon(Icons.waving_hand,color: Colors.amber,size:30,)
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text('What are you\nlooking for today?',style: TextStyle(
                               fontWeight: FontWeight.bold,
                                fontSize: 30,
                            )),

                          ],
                        ) ,

                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right:18.0,top: 8,bottom: 8 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        SmallText(text:'Education offers',size: 17,color: Colors.blue),
                        InkWell(
                          onTap: ()=>Get.to(()=>UserEduFeed()),
                          child:Row(
                            children: [
                              SmallText(text:'See all',size: 14,color: Colors.blue),
                              Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,size: 15,)
                            ],
                          ),
                        )
                      ],),
                    ),
                    SizedBox(
                      height: 250,
                      child: StreamBuilder<List<EduPostModel?>>(
                        stream: EduDb.eduPostsForHome,
                        builder:
                            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print(snapshot);
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length > 0) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                  height: 250,
                                  width: 200,
                                  margin: EdgeInsets.all(10),
                                  child: CustomCard(context, snapshot.data[index])
                                ),
                              );
                            }else{
                              return Center(child: Text('No Data to Show'));
                            }
                          } else {
                            return Center(child: Text('No Data to Show'));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right:18.0,top: 8,bottom: 8 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(text:'Volunteer offers',size: 17,color: Colors.blue),
                          InkWell(
                            onTap: ()=>Get.to(()=>UserVolFeed()),
                            child:Row(
                              children: [
                                SmallText(text:'See all',size: 14,color: Colors.blue),
                                Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,size: 15,)
                              ],
                            ),
                          )
                        ],),
                    ),
                    SizedBox(
                      height: 250,
                      child: StreamBuilder<List<VolPostModel?>>(
                        stream: VolDb.eduPostsForHome,
                        builder:
                            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print(snapshot);
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length > 0) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                    height: 250,
                                    width: 200,
                                    margin: EdgeInsets.all(10),
                                    child: CustomCardVol(context, snapshot.data[index])
                                ),
                              );
                            }else{
                              return Center(child: Text('No Data to Show'));
                            }
                          } else {
                            return Center(child: Text('No Data to Show'));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right:18.0,top: 8,bottom: 8 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(text:'Donations Requests',size: 17,color: Colors.blue),
                          InkWell(
                            onTap: ()=>Get.to(()=>UserDonFeed()),
                            child:Row(
                              children: [
                                SmallText(text:'See all',size: 14,color: Colors.blue),
                                Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,size: 15,)
                              ],
                            ),
                          )
                        ],),
                    ),
                    SizedBox(
                      height: 250,
                      child: StreamBuilder<List<DonPostModel?>>(
                        stream: DonDb.eduPostsForHome,
                        builder:
                            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print(snapshot);
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            if(snapshot.data.length > 0) {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Container(
                                    height: 250,
                                    width: 200,
                                    margin: EdgeInsets.all(10),
                                    child: CustomCardDon(context, snapshot.data[index])
                                ),
                              );
                            }else{
                              return Center(child: Text('No Data to Show'));
                            }
                          } else {
                            return Center(child: Text('No Data to Show'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ),

        )
    );
  }
}




Widget CustomCard(BuildContext context, EduPostModel model) {
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0.r),
    ),
    child: InkWell(
      onTap: () {
        Get.to(()=>UserEduView(model: model));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Flexible(
                  child: new Container(
                    child: Column(
                        children:[ BigText(
                          text: model.title!,
                          color: Colors.grey[600],size: 15.sp,
                        ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [

                SmallText(text:"posted "+timeago.format(model.createdAt!),color: Colors.grey[800]),
              ],
            ),
            Divider(color: Colors.grey),
            CachedNetworkImage(
              imageUrl:model.thumbnailUrl != '' ? model.thumbnailUrl! : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
              imageBuilder: (context, imageProvider) => Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:imageProvider,
                          fit: BoxFit.cover
                      )
                  )
              ),
              placeholder: (context, url) => Center(child:CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget CustomCardVol(BuildContext context, VolPostModel model) {
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0.r),
    ),
    child: InkWell(
      onTap: () {
        Get.to(()=>UserVolView(model: model));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Flexible(
                  child: new Container(
                    child: Column(
                        children:[ BigText(
                          text: model.title!,
                          color: Colors.grey[600],size: 15.sp,
                        ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [

                SmallText(text:"posted "+timeago.format(model.createdAt!),color: Colors.grey[800]),
              ],
            ),
            Divider(color: Colors.grey),
            CachedNetworkImage(
              imageUrl:model.thumbnailUrl != '' ? model.thumbnailUrl! : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
              imageBuilder: (context, imageProvider) => Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:imageProvider,
                          fit: BoxFit.cover
                      )
                  )
              ),
              placeholder: (context, url) => Center(child:CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget CustomCardDon(BuildContext context, DonPostModel model) {
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0.r),
    ),
    child: InkWell(
      onTap: () {
        Get.to(()=>UserDonView(model: model));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Flexible(
                  child: new Container(
                    child: Column(
                        children:[ BigText(
                          text: model.title!,
                          color: Colors.grey[600],size: 15.sp,
                        ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [

                SmallText(text:"posted "+timeago.format(model.createdAt!),color: Colors.grey[800]),
              ],
            ),
            Divider(color: Colors.grey),
            CachedNetworkImage(
              imageUrl:model.thumbnailUrl != '' ? model.thumbnailUrl! : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
              imageBuilder: (context, imageProvider) => Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:imageProvider,
                          fit: BoxFit.cover
                      )
                  )
              ),
              placeholder: (context, url) => Center(child:CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
      ),
    ),
  );
}

