import 'package:assignment/constants/app_colors/app_colors.dart';
import 'package:assignment/features/on_boarding/controller/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../map_location/view/map_location.dart' show LocationScreen;

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});

  final OnBoardingController controller = Get.put(OnBoardingController());

  final List<Map<String, String>> onboardingData = [
    {
      'title': "Sync with Nature’s \nRhythm",
      'description':
          "Experience a peaceful transition into the\nevening with an alarm that aligns with the\nsunset. Your perfect reminder, always 15 minutes b\nefore sundown",
      'image': 'asset/images/onboarding.png',
    },
    {
      'title': 'Effortless & Automatic',
      'description':
          "No need to set alarms manually. Wakey\ncalculates the sunset time for your\nlocation and alerts you on time.",
      'image': 'asset/images/onboarding2.png',
    },
    {
      'title': 'Relax & Unwind',
      'description': "hope to take the courage to pursue your\ndreams.",
      'image': 'asset/images/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   end: Alignment.topRight,
          //   begin: Alignment.bottomLeft,
          //   colors: [Color(0xFFE7B10A), Color(0x0ff9d949)],
          // ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 50),
                // Details of On Boarding Screen
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          Container(
                            height: 200, // Reduced height
                            width: double.infinity, // Reduced width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              height: 286,
                              width: double.infinity,
                              onboardingData[index]['image']!,
                              fit: BoxFit
                                  .cover, // Show full image without cropping
                            ),
                          ),
                          SizedBox(height: 40),
                          // Title
                          Text(
                            onboardingData[index]['title']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Description
                          Text(
                            onboardingData[index]['description']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Dots Indicator
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: controller.currentPage.value == index ? 10 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Obx(
                    () => Column(
                      children: [
                        //Button For Next
                        ElevatedButton(
                          onPressed: () {
                            if (controller.currentPage.value ==
                                onboardingData.length - 1) {
                              //Get.offAllNamed('/LocationScreen');
                              Get.to(LocationScreen());
                            } else {
                              controller.nextPage();
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.fullblack,
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.all(25),
                            minimumSize: Size(50, 15), // Full width
                          ),
                          child:
                              controller.currentPage.value ==
                                  onboardingData.length - 1
                              ? Icon(Icons.arrow_forward_rounded, size: 25)
                              : Icon(Icons.arrow_forward_rounded, size: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
