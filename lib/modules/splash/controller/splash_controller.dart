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

    if (!isOnboarded) {
      Get.offAllNamed(RoutesName.onboarding);
    } else if (isLoggedIn) {
      Get.offAllNamed(RoutesName.home);
    } else {
      Get.offAllNamed(RoutesName.login);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
