import 'package:ctse_assignment01/src/custom_widget/custom_small_text/custom_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomExpandableText extends StatefulWidget {
  final String text;

  CustomExpandableText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<CustomExpandableText> createState() => _CustomExpandableTextState();
}

class _CustomExpandableTextState extends State<CustomExpandableText> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHeight = 250.w;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(text:firstHalf,size:12.sp,color: Colors.black45,height: 1.8,)
          : Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
              children: [
                SmallText(color: Colors.black45,height: 1.8,text: hiddenText ? (firstHalf + "..") : (firstHalf + secondHalf),),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      Text('Show more', style: TextStyle(color: Colors.blue)),
                      Icon(hiddenText ?Icons.arrow_drop_down:Icons.arrow_drop_up ,color: Colors.blue ,)
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
