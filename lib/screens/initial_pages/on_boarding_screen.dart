import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yabyab_app/core/local_data/catch_helper.dart';
import 'package:yabyab_app/core/services/services_locator.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/initial_pages/data/onBoarding_model.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/general_enter_app.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const String routeName = 'OnBoardingScreen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  int currentIndex = 0;
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 20,
              ),
              isLastPage
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        controller.jumpToPage(2);
                      },
                      child: const Text(AppStrings.skip,
                          style: AppTextStyle.styleRegularGrey20),
                    ),
              isLastPage
                  ? SizedBox(
                      height: height * .08,
                    )
                  : SizedBox(
                      height: height * .05,
                    ),
              Expanded(
                  child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                        if (value + 1 ==
                            OnBoardingModel.onBoardingScreens.length) {
                          setState(() {
                            isLastPage = true;
                          });
                        } else {
                          setState(() {
                            isLastPage = false;
                          });
                        }
                      },
                      controller: controller,
                      itemCount: OnBoardingModel.onBoardingScreens.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Image.asset(OnBoardingModel
                              .onBoardingScreens[index].imagePath),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              effect: const ExpandingDotsEffect(
                                activeDotColor: AppColors.darkGreenColor,
                                dotHeight: 8,
                                dotColor: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            OnBoardingModel.onBoardingScreens[index].title,
                            style: AppTextStyle.styleRegularBlack20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width,
                            child: Text(
                              OnBoardingModel.onBoardingScreens[index].subTitle,
                              style: AppTextStyle.styleRegularBlack16,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          SizedBox(
                            width: width * .8,
                            child: ElevatedButton(
                              onPressed: () async {
                                await getIt<CacheHelper>()
                                    .setData(key: 'isVisited', value: true)
                                    .then((value) {
                                  index == 2
                                      ? Navigator.pushReplacementNamed(
                                          context, GeneralEnterApp.routeName)
                                      : controller.nextPage(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve:
                                              Curves.fastEaseInToSlowEaseOut);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreenColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20),
                                child: Text(
                                  OnBoardingModel
                                      .onBoardingScreens[index].nextBottom,
                                  style: AppTextStyle.styleRegularGrey20
                                      .copyWith(
                                          fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ]);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
