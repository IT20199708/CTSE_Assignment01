
import 'package:ctse_assignment01/src/controllers/on_board_controller/on_board_controller.dart';
import 'package:ctse_assignment01/src/custom_widget/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../auth_screen/auth_main_screen/auth_main_screen.dart';



class OnBoardingScreen extends StatelessWidget {

   OnBoardingScreen({Key? key}) : super(key: key);
   final onBoardController = OnBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:Stack(
        alignment:Alignment.center,
          children: [
            Obx(
              () => LiquidSwipe(pages:onBoardController.pages,
              enableSideReveal:true,
              liquidController:onBoardController.controller,
              onPageChangeCallback:onBoardController.onPageChangedCallBack ,
              slideIconWidget:onBoardController.lastPage.value == true ? null: Icon(Icons.arrow_back_ios),
              enableLoop: false,
              waveType: WaveType.liquidReveal,

      ),
            ),

            Positioned(
              bottom: 40.0.h,
              child:Container(
                  padding: EdgeInsets.symmetric(horizontal:17.w),
                  alignment: Alignment.center,
                  child:CustomButton(onPressed:()=>Get.off(AuthMainScreen()) ,BtnText: "Get Started",Btnwidth: 300.w,)),
            ),
            Positioned(
              top: 50.h,
              right: 20.w,
              child: TextButton(
                onPressed: () => onBoardController.skip(),
                child: Row(children: [
                  Text("Skip", style: TextStyle(color: Colors.black45,)),
                  Icon(Icons.arrow_forward)
    ],),
              ),
            ),
            Obx(
                  () => Positioned(
                bottom: 10.h,
                child: AnimatedSmoothIndicator(
                  count: 3,
                  activeIndex: onBoardController.curruntPage.value,
                  effect: const WormEffect(
                    activeDotColor: Color(0xff272727),
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }


}
