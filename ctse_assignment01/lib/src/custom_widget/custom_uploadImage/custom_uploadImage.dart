import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUploadImage extends StatelessWidget {
  CustomUploadImage({Key? key,this.imageFile, required this.onPressed, this.isUpdating=false, this.url,}) : super(key: key);
  final File? imageFile;
  final VoidCallback onPressed;
  final bool? isUpdating ;
  final String? url;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Upload Thumbnail',style: Theme.of(context).textTheme.subtitle1),
          Text('(This image will be displayed along with this post)'),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: onPressed, icon: Icon(Icons.camera_alt))
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height:200.h,
            child: Image(image: imageFile != null ? FileImage(imageFile!)  as ImageProvider : NetworkImage(isUpdating! ? url! :'https://firebasestorage.googleapis.com/v0/b/edushareflutter-1358a.appspot.com/o/EduShareThumbnail.jpg?alt=media&token=ad43151d-9618-4acb-a020-e5c4dbbad71f')),
          )
        ],
      ),
    );
  }
}
