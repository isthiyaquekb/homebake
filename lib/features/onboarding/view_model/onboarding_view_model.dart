import 'package:flutter/cupertino.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/onboarding/model/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier{
  var selectedPageIndex=0;
  bool get isLastPage=>selectedPageIndex==onBoardingPageList.length-1;
  var pageController=PageController();

  goToNext(BuildContext context) {
    if(isLastPage){
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }else{
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    notifyListeners();
  }

  void changeOnboardPage(int pageNumber){
    selectedPageIndex=pageNumber;
    notifyListeners();
  }

  List<OnBoardingModel> onBoardingPageList=[
    OnBoardingModel(AppAssets.onBoard1, "Fresh and Delicious", 'Freshly baked by hand and with love'),
    OnBoardingModel(AppAssets.onBoard2, "Easy Connecting", 'Connect with ease and convenience, anytime and anywhere.'),
    OnBoardingModel(AppAssets.onBoard3, "Made locally with \nLove & care", 'We encourage you to step in to our home at anytime and get yourself a freshly baked one.')
  ];

}