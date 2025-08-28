import 'package:assignment/common_widgets/custom_button.dart';
import 'package:assignment/common_widgets/custom_text.dart';
import 'package:assignment/constants/app_colors/app_colors.dart';
import 'package:assignment/constants/app_images/app_images.dart';
import 'package:assignment/features/map_location/view/selected_location.dart';
import 'package:assignment/features/set_alams/view/home_alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    CustomText(
                      title: "Welcome! Your\nPersonalized Alarm",
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    CustomText(
                      title:
                          "Allow us to sync your sunset alarm\nbased on your location.",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Image.asset(AppImages.location, height: 300, fit: BoxFit.cover),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(SelectedLocation());
                  },
                  child: CustomButton(
                    title: "Use Current Location",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Get.to(HomeAlarm());
                  },
                  child: CustomButton(
                    title: "Home",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
