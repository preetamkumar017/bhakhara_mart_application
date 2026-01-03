import 'package:get/get.dart';
import '../../../res/routes/routes_name.dart';

class OnboardingController extends GetxController {
  void goToLogin() {
    Get.offAllNamed(RoutesName.login);
  }
}

