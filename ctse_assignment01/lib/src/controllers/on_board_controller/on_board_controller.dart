import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../constants/colors/colors.dart';
import '../../constants/images/images.dart';
import '../../constants/text/text.dart';
import '../../custom_widget/on_board_screen_layout/on_board_screen_layout.dart';
import '../../models/on_board_model/OnBoardModel.dart';

class OnBoardController extends GetxController{
  final controller = LiquidController();
  RxInt curruntPage = 0.obs;
  RxBool lastPage = false.obs;

  final pages = [
    OnBoardScreenLayout(
      model: OnBoardModel(
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        bgColor: tOnBoardingPage1Color,
      ),
    ),
    OnBoardScreenLayout(
      model: OnBoardModel(
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        bgColor: tOnBoardingPage2Color,
      ),
    ),
    OnBoardScreenLayout(
      model: OnBoardModel(
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        bgColor: tOnBoardingPage3Color,
      ),
    ),
  ];
  skip()=>controller.jumpToPage(page: 2);
  animateToNextSlide(){
    int nextPage = controller.currentPage + 1 ;
    controller.animateToPage(page: nextPage);
  }
  onPageChangedCallBack(int activePageIndex){
    print(activePageIndex);

    if(activePageIndex == 2){
      lastPage.value = true;
    }else{
      lastPage.value = false;
    }
    print(lastPage.value);
    curruntPage.value = activePageIndex;
  }
}