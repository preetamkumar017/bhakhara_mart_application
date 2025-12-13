import 'package:get/get.dart';

class ProductController extends GetxController {
  late Map<String, dynamic> product;
  final quantity = 1.obs;
  final selectedWeightIndex = 0.obs;
  final expandedSections = <String, bool>{
    'highlights': false,
    'specifications': false,
    'returnPolicy': false,
  }.obs;

  final weightOptions = ['32g', '140g', '280g', '420g', '560g'];

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments ?? {};
    // Set default weight if available
    if (product['weight'] != null) {
      final weight = product['weight'] as String;
      final index = weightOptions.indexWhere((w) => weight.contains(w.replaceAll('g', '')));
      if (index >= 0) {
        selectedWeightIndex.value = index;
      }
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void selectWeight(int index) {
    selectedWeightIndex.value = index;
  }

  void toggleSection(String section) {
    expandedSections[section] = !(expandedSections[section] ?? false);
  }

  void addToCart() {
    final cartProduct = {
      ...product,
      'quantity': quantity.value,
      'selectedWeight': weightOptions[selectedWeightIndex.value],
    };
    Get.back(result: cartProduct);
    Get.snackbar('Added', '${product['name']} added to cart');
  }
}

