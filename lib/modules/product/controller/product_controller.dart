import 'package:get/get.dart';
import '../repo/product_repo.dart';
import '../../../data/models/product_model.dart';
import '../widgets/product_filter_bottom_sheet.dart';

class ProductController extends GetxController {
  final ProductRepo _repo = ProductRepo();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final page = 1.obs;
  final error = ''.obs;

  final quantity = 1.obs;
  final currentCategoryId = ''.obs;
  final filterOptions = ProductFilterOptions().obs;

  Future<void> loadProducts(String categoryId, {ProductFilterOptions? filters, bool force = false}) async {
    // If not forced and already loaded for this category with no new filters, skip re-fetch
    if (!force && currentCategoryId.value == categoryId && products.isNotEmpty && filters == null) {
      return;
    }

    currentCategoryId.value = categoryId;
    if (filters != null) {
      filterOptions.value = filters;
    }

    page.value = 1;
    hasMore.value = true;
    isLoadingMore.value = false;

    try {
      isLoading.value = true;
      error.value = '';

      final data = await _repo.getProducts(
        categoryId,
        filters: filterOptions.value,
        page: 1,
        limit: 20,
      );
      products.assignAll(data);
      hasMore.value = data.length >= 20;
    } catch (e) {
      error.value = 'Unable to load products. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value || currentCategoryId.value.isEmpty) {
      return;
    }

    try {
      isLoadingMore.value = true;
      final nextPage = page.value + 1;

      final data = await _repo.getProducts(
        currentCategoryId.value,
        filters: filterOptions.value,
        page: nextPage,
        limit: 20,
      );

      products.addAll(data);
      page.value = nextPage;
      hasMore.value = data.length >= 20;
    } catch (e) {
      // allow retry on next scroll
    } finally {
      isLoadingMore.value = false;
    }
  }

  void applyFilters(ProductFilterOptions filters) {
    filterOptions.value = filters;
    if (currentCategoryId.value.isNotEmpty) {
      loadProducts(currentCategoryId.value, filters: filters, force: true);
    }
  }

  void increaseQty() => quantity.value++;

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}
