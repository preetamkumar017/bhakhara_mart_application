import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';
import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../repo/category_repo.dart';
import '../../product/repo/product_repo.dart';

class HomeController extends GetxController {
  final CategoryRepo _categoryRepo = CategoryRepo();
  final ProductRepo _productRepo = ProductRepo();
  final CartController cartController = Get.find<CartController>();

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;

  final isCategoryLoading = false.obs;
  final isProductLoading = false.obs;

  final selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isCategoryLoading.value = true;
      final data = await _categoryRepo.fetchCategories();
      categories.assignAll(data);

      if (categories.isNotEmpty) {
        selectCategory(categories.first.id);
      }
    } finally {
      isCategoryLoading.value = false;
    }
  }

  Future<void> selectCategory(String categoryId) async {
    selectedCategoryId.value = categoryId;
    await loadProductsByCategory(categoryId);
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    try {
      isProductLoading.value = true;
      final data = await _productRepo.getProducts(categoryId);
      products.assignAll(data);
    } finally {
      isProductLoading.value = false;
    }
  }

  int get cartItemCount => cartController.totalItems;

  // Navigation helpers
  void openProduct(ProductModel product) {
    Get.toNamed('/product-detail', arguments: product);
  }

  void addToCart(ProductModel product) {
    cartController.addItem(int.parse(product.id));
  }

  void openCart() => Get.toNamed('/cart');
  void openSearch() => Get.toNamed('/search');
  void openProfile() => Get.toNamed('/profile');
}
