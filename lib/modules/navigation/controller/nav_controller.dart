import 'package:get/get.dart';

class NavController extends GetxController {
  final currentIndex = 0.obs;

  void switchTab(int index) {
    currentIndex.value = index;
  }
}

