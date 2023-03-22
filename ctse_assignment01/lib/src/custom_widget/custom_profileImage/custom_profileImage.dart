import 'dart:io';

import 'package:ctse_assignment01/src/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class CustomProfileImage extends StatelessWidget {
  CustomProfileImage(
      {Key? key,
      this.imagePath,
        this.imageFile,
      required this.onPressed,
      required this.isNetWorkImage})
      : super(key: key);
  final String? imagePath;
  final File? imageFile;
  final VoidCallback onPressed;
  final bool isNetWorkImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
              bottom: 0,
              right: 4,
              child: buildCamaraBtn(tPrimaryColor))
        ],
      ),
    );
  }

  Widget buildImage() {
    final image =  isNetWorkImage ? NetworkImage(imagePath!) : FileImage(imageFile!)  as ImageProvider  ;
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(
              onTap: onPressed,
            )),
      ),
    );
  }

  Widget buildCamaraBtn(Color color) {
    return buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
          color: color,
          all: 8,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          )),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child:
          Container(padding: EdgeInsets.all(all), color: color, child: child),
    );
  }
}
