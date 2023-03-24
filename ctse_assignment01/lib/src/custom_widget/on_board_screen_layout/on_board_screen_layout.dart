import 'package:ctse_assignment01/src/custom_widget/custom_headline_text/custom_headline_text.dart';
import 'package:ctse_assignment01/src/models/on_board_model/OnBoardModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/sizes/sizes.dart';

class OnBoardScreenLayout extends StatelessWidget {

  final OnBoardModel model;

  const OnBoardScreenLayout({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(tDefaultSize),
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(model.image),
            height: size.height * 0.45,
          ),
          Column(
            children: [
              CustomHeadlineText(text: model.title),
              Text(
                model.subTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(
            height: 80.0,
          )
        ],
      ),
    );
  }
}
