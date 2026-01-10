import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final user = {'name': 'Demo User', 'email': 'demo@mart.com'}.obs;

  void logout() {
    // Clear user info
    user.value = {};

    // Clear storage
    final _storage = GetStorage();
    _storage.erase();

    // Remove all Getx controllers (cache)
    Get.deleteAll(force: true);

    // Navigate to login page
    Get.offAllNamed('/login');
  }
}
