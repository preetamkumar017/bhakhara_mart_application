import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../repo/category_repo.dart';
import '../../product/repo/product_repo.dart';
import '../../cart/controller/cart_controller.dart';

class CategoryTab {
  final String id;
  final String name;

  CategoryTab(this.id, this.name);
}

class HomeController extends GetxController {
  final CategoryRepo _categoryRepo = CategoryRepo();
  final ProductRepo _productRepo = ProductRepo();
  final CartController cartController = Get.find<CartController>();

  final isCategoryLoading = false.obs;
  final isProductLoading = false.obs;

  /// Tabs (All + Categories)
  final tabs = <CategoryTab>[].obs;

  /// Cache products per category
  final productsMap = <String, List<ProductModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  // ================= CATEGORIES =================

  Future<void> loadCategories() async {
    try {
      isCategoryLoading.value = true;

      final data = await _categoryRepo.fetchCategories();

      tabs.clear();
      tabs.add(CategoryTab('all', 'All'));
      tabs.addAll(data.map((e) => CategoryTab(e.id, e.name)));

      // default load ALL products
      loadProducts('all');
    } finally {
      isCategoryLoading.value = false;
    }
  }

  void onTabChanged(int index) {
    final tab = tabs[index];
    if (!productsMap.containsKey(tab.id)) {
      loadProducts(tab.id);
    }
  }

  // ================= PRODUCTS =================

  Future<void> loadProducts(String categoryId) async {
    try {
      isProductLoading.value = true;

      final data = categoryId == 'all'
          ? await _productRepo.getAllProducts()
          : await _productRepo.getProducts(categoryId);

      productsMap[categoryId] = data;
    } finally {
      isProductLoading.value = false;
    }
  }

  // ================= PRODUCT ACTIONS =================
  /// 🔥 REQUIRED BY ProductCard

  void openProduct(ProductModel product) {
    Get.toNamed(
      '/product-detail',
      arguments: product,
    );
  }

  void addToCart(ProductModel product) {
    // Prevent duplicate entries - check if already in cart
    final productId = product.id;
    if (cartController.isInCart(productId)) {
      Get.snackbar(
        'Already in Cart',
        '${product.productName} is already in your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    cartController.addItem(int.parse(productId));
  }

  // ================= CART STATE CHECK =================
  /// Reactive check if a product is in cart
  /// Used by ProductCard to show "Added" status
  /// Triggers rebuild when cart changes
  bool isProductInCart(String productId) {
    return cartController.isInCart(productId);
  }

  /// Get quantity of product in cart (returns 0 if not in cart)
  int getProductQuantity(String productId) {
    final cartItem = cartController.getCartItem(productId);
    return cartItem?.quantity.toInt() ?? 0;
  }

  /// Trigger UI rebuild when cart changes
  /// Call this after cart operations
  void refreshCartState() {
    update(); // Updates all GetBuilder listeners
  }

  // ================= COMMON =================

  int get cartItemCount => cartController.totalItems;

  void openCart() => Get.toNamed('/cart');
  void openSearch() => Get.toNamed('/search');
}
