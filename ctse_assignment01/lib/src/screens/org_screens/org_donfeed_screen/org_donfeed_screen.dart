import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_drawer/custom_drawer.dart';
import 'package:ctse_assignment01/src/forms/don_form/don_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/org_controller/org_controller.dart';
import '../../../custom_widget/custom_big_text/custom_big_text.dart';
import '../../../models/don_post_model/don_post_model.dart';
import '../../../services/db/don/donDb.dart';
import '../../../utils/snack_bar/snack_bar.dart';

class OrgDonFeed extends StatefulWidget {
  const OrgDonFeed({Key? key}) : super(key: key);

  @override
  State<OrgDonFeed> createState() => _OrgDonFeedState();
}

class _OrgDonFeedState extends State<OrgDonFeed> {
  final orgController = OrgController();
  final _searchController = TextEditingController();
  var searchName = '';

  @override
  void initState() {
    super.initState();
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
          title:Text("Your Donation Posts"),
          centerTitle: true,
          iconTheme: IconThemeData(color:Colors.white),
        ),
        drawer:CustomDrawer(),
        floatingActionButton:buildNavigateFAB(),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Post Title",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed:(){
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
                      stream: DonDb.eduPosts,
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


  Widget buildNavigateFAB()=>FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text("Add"),
      onPressed: ()=>Get.to(()=>DonForm()));

  Widget CustomCard(BuildContext context, DonPostModel model) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      child: InkWell(
        onTap: () {},
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
              SizedBox(height: 20.h),
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
              SizedBox(height: 10.h),
              Divider(height: 1, color: Colors.black26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                      onPressed: (){
                        Get.to(()=>DonForm(id:model.id!,updateModel:model,));
                      },
                      icon: Icon(Icons.edit),
                      label: Text("Edit")),
                  Divider(),
                  TextButton.icon(
                      onPressed: () {
                        _showBottomSheet(model.id!);
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(String id) {
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
                                await DonDb.deletePost(id: id);
                                Navigator.of(context).pop();
                                CustomSnackBars.showSuccessSnackBar('Post deleted successfully');
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
}
