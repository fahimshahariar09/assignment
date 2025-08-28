import 'package:assignment/common_widgets/custom_text.dart';
import 'package:assignment/features/on_boarding/controller/on_boarding_controller.dart';
import 'package:assignment/features/welcome/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});

  final OnBoardingController controller = Get.put(OnBoardingController());

  final List<Map<String, String>> onboardingData = [
    {
      'title': "Sync with Nature’s \nRhythm",
      'description':
          "Experience a peaceful transition into the\nevening with an alarm that aligns with the\nsunset. Your perfect reminder, always 15\nminutes before sundown",
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
      'description': "Hope to take the courage to pursue your\ndreams.",
      'image': 'asset/images/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Full PageView including image
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black54, // Dark overlay for contrast
                  child: Column(
                    children: [
                      // Image Container with fixed height
                      Container(
                        height: 430,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              onboardingData[index]['image']!,
                            ), // Dynamic image
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(WelcomeScreen());
                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text and Controls
                      SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          children: [
                            // Title
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                children: [
                                  CustomText(
                                    title: onboardingData[index]['title']!,
                                    textAlign: TextAlign.start,
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            // Description
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                children: [
                                  CustomText(
                                    title:
                                        onboardingData[index]['description']!,
                                    textAlign: TextAlign.start,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                              width: controller.currentPage.value == index
                                  ? 10
                                  : 8,
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
                      // Next Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: () {
                              if (controller.currentPage.value ==
                                  onboardingData.length - 1) {
                                Get.to(WelcomeScreen());
                              } else {
                                controller.nextPage();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                0xFF6B4E99,
                              ), // Purple color
                              foregroundColor: Colors.white,
                              minimumSize: Size(
                                double.infinity,
                                50,
                              ), // Full width
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child:
                                controller.currentPage.value ==
                                    onboardingData.length - 1
                                ? Text(
                                    'Get Started',
                                    style: TextStyle(fontSize: 16),
                                  )
                                : Text('Next', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
