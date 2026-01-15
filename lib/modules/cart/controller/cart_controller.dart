import 'package:get/get.dart';
import '../repo/cart_repo.dart';
import '../../../data/models/cart_model.dart';
import '../../../modules/home/controller/home_controller.dart';

class CartController extends GetxController {
  final CartRepo _repo = CartRepo();

  final items = <CartItemModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    items.assignAll(await _repo.fetchCart());
    isLoading.value = false;

    // Trigger UI refresh across the app (ProductCard, etc.)
    _refreshHomeController();
  }

  /// Refresh HomeController to update ProductCard UI
  void _refreshHomeController() {
    try {
      final homeController = Get.find<HomeController>();
      homeController.refreshCartState();
    } catch (e) {
      // HomeController might not be initialized yet
    }
  }

  Future<void> addItem(int productId) async {
    await _repo.addToCart(productId, 1);
    await loadCart();
  }

  Future<void> increaseQty(CartItemModel item) async {
    await _repo.updateCart(
      int.parse(item.productId),
      item.quantity.toInt() + 1,
    );
    await loadCart();
  }

  Future<void> decreaseQty(CartItemModel item) async {
    if (item.quantity <= 1) {
      await removeItem(item);
    } else {
      await _repo.updateCart(
        int.parse(item.productId),
        item.quantity.toInt() - 1,
      );
      await loadCart();
    }
  }

  Future<void> removeItem(CartItemModel item) async {
    await _repo.removeFromCart(int.parse(item.productId));
    await loadCart();
  }

  int get totalItems => items.length;

  double get totalAmount =>
      items.fold(0, (sum, e) => sum + e.subtotal);

  // ================= CART STATE CHECK =================
  /// Check if a product is already in cart by productId
  /// Returns true if product exists in cart items
  bool isInCart(String productId) {
    return items.any((item) => item.productId == productId);
  }

  /// Get cart item by productId (returns null if not in cart)
  CartItemModel? getCartItem(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}
