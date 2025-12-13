import 'package:get/get.dart';

class CartController extends GetxController {
  final items = [
    {'name': 'Fresh Apples', 'qty': 1, 'price': 120},
    {'name': 'Organic Milk', 'qty': 2, 'price': 65},
  ].obs;

  double get total => items.fold(0, (sum, item) => sum + (item['qty'] as int) * (item['price'] as num));

  void checkout() {
    Get.toNamed('/checkout');
  }
}

