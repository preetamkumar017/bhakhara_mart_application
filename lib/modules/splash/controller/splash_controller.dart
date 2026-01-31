import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../res/routes/routes_name.dart';

class SplashController extends GetxController {
  Timer? _timer;
  final _box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final bool isOnboarded = _box.read('isOnboarded') ?? false;
    final bool isLoggedIn = _box.read('isLoggedIn') ?? false;

    // Priority 1: If logged in, go directly to home (skip onboarding)
    if (isLoggedIn) {
      Get.offAllNamed(RoutesName.home);
    } 
    // Priority 2: If not logged in but not onboarded, show onboarding
    else if (!isOnboarded) {
      Get.offAllNamed(RoutesName.onboarding);
    } 
    // Priority 3: If onboarded but not logged in, show login
    else {
      Get.offAllNamed(RoutesName.login);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
