import 'package:get/get.dart';
import '../repo/cart_repo.dart';
import '../../../data/models/cart_model.dart';

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
}
