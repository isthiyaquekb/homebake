import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingProvider=context.read<OnboardingViewModel>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Stack(
        children: [
          Consumer<OnboardingViewModel>(builder: (context, value, child) => PageView.builder(
              controller: value.pageController,
              onPageChanged: (change) {
                value.changeOnboardPage(change);
              },
              itemCount: value.onBoardingPageList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            value
                                .onBoardingPageList[index].imageAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          value
                              .onBoardingPageList[index].title,
                          textAlign: TextAlign.center,
                          // style: GoogleFonts.poppins(color: AppColor.primaryTextColor,fontSize: 24,fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          value
                              .onBoardingPageList[index].description,
                          textAlign: TextAlign.center,
                          // style: GoogleFonts.poppins(color: AppColor.primaryTextColor,fontSize: 18,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }),),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width * 0.4,
            right: MediaQuery.of(context).size.width * 0.4,
            child: SmoothPageIndicator(
              controller: onboardingProvider.pageController,
              count: 3,
              effect:  ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 12,
                dotColor: Colors.green.withOpacity(0.7),
                activeDotColor: Colors.red.withOpacity(0.7),
                expansionFactor: 3,
                // strokeWidth: 5,
              ),
            ),
          ),
          Consumer<OnboardingViewModel>(builder: (context, provider, child) => Positioned(
            bottom: 24,
            right: 24,
            child: provider.selectedPageIndex != 2
                ? InkWell(
              borderRadius: BorderRadius.circular(42),
              onTap: () => provider.goToNext(context),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(42)),
                  height: 42,
                  width: 42,
                  child: SvgPicture.asset(AppAssets.nextIcon,colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),)),
            )
                : InkWell(
              borderRadius: BorderRadius.circular(42),
              onTap: () => provider.goToNext(context),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                  color: AppColor.blue.withOpacity(0.4),borderRadius: BorderRadius.circular(5)
                  ),
                  child:  Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text("Get Started",style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ),
                ),
              )
            ),
          ),),
          Positioned(
            top: 24,
            right: 0,
            child: InkWell(
              onTap: (){
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 24.0,top: 40),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor.blue.withOpacity(0.4),borderRadius: BorderRadius.circular(5)
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Text("Skip",style: Theme.of(context).textTheme.labelMedium),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
