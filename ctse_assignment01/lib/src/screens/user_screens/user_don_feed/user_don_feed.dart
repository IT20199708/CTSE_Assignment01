
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_big_text/custom_big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/org_controller/org_controller.dart';
import '../../../custom_widget/custom_user_drawer/custom_user_drawer.dart';
import '../../../models/don_post_model/don_post_model.dart';
import '../../../services/db/don/donDb.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../user_don_view/user_don_view.dart';

class UserDonFeed extends StatefulWidget {
  const UserDonFeed({Key? key}) : super(key: key);
  @override
  State<UserDonFeed> createState() => _UserDonFeedState();
}
class _UserDonFeedState extends State<UserDonFeed> {
  final orgController = OrgController();
  var searchName = '';
  var _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchName = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title:Text("Donation Feed"),
          centerTitle: true,
          iconTheme: IconThemeData(color:Colors.white),
        ),
        drawer:CustomUserDrawer(),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                      controller:_searchController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Post Title",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                searchName = '';
                              });
                              _searchController.clear();
                            },
                            icon: Icon(Icons.clear)),
                      )),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: StreamBuilder<List<DonPostModel?>>(
                      stream: DonDb.eduPostsForUser,
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
                                itemBuilder: (context, index) {
                                  DonPostModel post =snapshot.data[index];
                                  if(searchName.isEmpty){
                                    return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child:
                                        CustomCard(context, snapshot.data[index]));
                                  }
                                  if(post.title.toString().toLowerCase().contains(searchName)){
                                    return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child:
                                        CustomCard(context, snapshot.data[index]));
                                  }
                                  return Container();
                                });
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
            )));
  }


  Widget CustomCard(BuildContext context, DonPostModel model) {
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
                  CircleAvatar(backgroundImage: NetworkImage(model.userAvatar!)),
                  SizedBox(width: 16.w),
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
                  SizedBox(width: 50.w,height: 20.h),
                  Text("posted "+timeago.format(model.createdAt!)),
                ],
              ),
              Divider(color: Colors.grey),
              CachedNetworkImage(
                imageUrl:model.thumbnailUrl != '' ? model.thumbnailUrl! : "https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f",
                imageBuilder: (context, imageProvider) => Container(
                    height: 200.h,
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

}
