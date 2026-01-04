import 'package:get/get.dart';
import '../../modules/cart/controller/cart_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(
      CartController(),
      permanent: true,
    );
  }
}
