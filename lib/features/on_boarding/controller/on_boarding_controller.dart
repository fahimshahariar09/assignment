import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var currentPage = 0.obs; // Observable variable for current page
  final PageController pageController = PageController();

  @override
  void onInit() {
    // Initialize any late variables if needed
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pageController.page!.round()) {
      return; // Prevent manual next if already on the last page
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skip() {
    Get.offAllNamed('/signup'); // Navigate to signup instead of business_home
  }
}