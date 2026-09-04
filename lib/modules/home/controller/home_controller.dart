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
  
  /// Lazy initialization to avoid CartController not found error
  late final CartController cartController;

  final isCategoryLoading = false.obs;
  final isProductLoading = false.obs;

  /// Tabs (All + Categories)
  final tabs = <CategoryTab>[].obs;

  /// Cache products per category
  final productsMap = <String, List<ProductModel>>{}.obs;

  /// Per-category pagination state
  final pageMap = <String, int>{}.obs;
  final hasMoreMap = <String, bool>{}.obs;
  final isLoadingMoreMap = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    cartController = Get.find<CartController>();
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
      pageMap[categoryId] = 1;
      hasMoreMap[categoryId] = true;
      isLoadingMoreMap[categoryId] = false;

      final data = categoryId == 'all'
          ? await _productRepo.getAllProducts(page: 1, limit: 20)
          : await _productRepo.getProducts(categoryId, page: 1, limit: 20);

      productsMap[categoryId] = data;
      hasMoreMap[categoryId] = data.length >= 20;
    } catch (e) {
      // keep previous or empty list on failure
    } finally {
      isProductLoading.value = false;
    }
  }

  Future<void> loadMoreProducts(String categoryId) async {
    if (isLoadingMoreMap[categoryId] == true ||
        hasMoreMap[categoryId] == false ||
        isProductLoading.value) {
      return;
    }

    try {
      isLoadingMoreMap[categoryId] = true;
      final nextPage = (pageMap[categoryId] ?? 1) + 1;

      final data = categoryId == 'all'
          ? await _productRepo.getAllProducts(page: nextPage, limit: 20)
          : await _productRepo.getProducts(categoryId, page: nextPage, limit: 20);

      final current = productsMap[categoryId] ?? [];
      productsMap[categoryId] = [...current, ...data];
      pageMap[categoryId] = nextPage;
      hasMoreMap[categoryId] = data.length >= 20;
    } catch (e) {
      // ignore on pagination error to allow retry on next scroll
    } finally {
      isLoadingMoreMap[categoryId] = false;
    }
  }

  // ================= PRODUCT ACTIONS =================
  /// 🔥 REQUIRED BY ProductCard

  void openProduct(ProductModel product) {
    // Get.toNamed(
    //   '/product-detail',
    //   arguments: product,
    // );
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
