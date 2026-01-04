import 'package:get/get.dart';
import '../repo/product_repo.dart';
import '../../../data/models/product_model.dart';

class ProductController extends GetxController {
  final ProductRepo _repo = ProductRepo();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  final quantity = 1.obs;

  Future<void> loadProducts(String categoryId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.getProducts(categoryId);
      products.assignAll(data);
    } catch (e) {
      error.value = 'Unable to load products';
    } finally {
      isLoading.value = false;
    }
  }

  void increaseQty() => quantity.value++;

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}
