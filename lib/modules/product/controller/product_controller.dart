import 'package:get/get.dart';
import '../repo/product_repo.dart';
import '../../../data/models/product_model.dart';
import '../widgets/product_filter_bottom_sheet.dart';

class ProductController extends GetxController {
  final ProductRepo _repo = ProductRepo();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  final quantity = 1.obs;
  final currentCategoryId = ''.obs;
  final filterOptions = ProductFilterOptions().obs;

  Future<void> loadProducts(String categoryId, {ProductFilterOptions? filters}) async {
    currentCategoryId.value = categoryId;
    if (filters != null) {
      filterOptions.value = filters;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.getProducts(
        categoryId,
        filters: filterOptions.value,
      );
      products.assignAll(data);
    } catch (e) {
      error.value = 'Unable to load products. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters(ProductFilterOptions filters) {
    filterOptions.value = filters;
    if (currentCategoryId.value.isNotEmpty) {
      loadProducts(currentCategoryId.value, filters: filters);
    }
  }

  void increaseQty() => quantity.value++;

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}
