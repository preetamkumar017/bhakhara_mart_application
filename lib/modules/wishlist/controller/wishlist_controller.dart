import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/repo/cart_repo.dart';
import '../repo/wishlist_repo.dart';

class WishlistController extends GetxController {
  final WishlistRepo _repo = WishlistRepo();

  final wishlistItems = <ProductModel>[].obs;
  final isLoading = false.obs;
  final favoriteProductIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;
      final list = await _repo.fetchWishlist();
      wishlistItems.assignAll(list);
      favoriteProductIds.assignAll(
        list.map((p) => int.tryParse(p.id) ?? 0).where((id) => id > 0),
      );
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String productId) {
    final id = int.tryParse(productId) ?? 0;
    return favoriteProductIds.contains(id);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    final pid = int.tryParse(product.id) ?? 0;
    if (pid <= 0) return;

    final wasFavorite = favoriteProductIds.contains(pid);

    // Optimistic UI update
    if (wasFavorite) {
      favoriteProductIds.remove(pid);
      wishlistItems.removeWhere((p) => p.id == product.id);
    } else {
      favoriteProductIds.add(pid);
      wishlistItems.insert(0, product.copyWith(isFavorite: true));
    }

    try {
      final isNowFav = await _repo.toggleWishlist(pid);
      if (isNowFav) {
        favoriteProductIds.add(pid);
        Fluttertoast.showToast(msg: "Added '${product.productName}' to Favorites ❤️");
      } else {
        favoriteProductIds.remove(pid);
        Fluttertoast.showToast(msg: "Removed from Favorites");
      }
    } catch (e) {
      // Rollback on error
      if (wasFavorite) {
        favoriteProductIds.add(pid);
        wishlistItems.add(product);
      } else {
        favoriteProductIds.remove(pid);
        wishlistItems.removeWhere((p) => p.id == product.id);
      }
      Fluttertoast.showToast(msg: "Failed to update favorites");
    }
  }

  /// Move all in-stock items from wishlist to cart
  Future<void> addAllToCart() async {
    if (wishlistItems.isEmpty) return;

    final CartRepo cartRepo = CartRepo();
    int addedCount = 0;

    for (final item in wishlistItems) {
      final pid = int.tryParse(item.id) ?? 0;
      if (pid > 0 && item.isInStock) {
        try {
          await cartRepo.addToCart(pid, 1);
          addedCount++;
        } catch (_) {}
      }
    }

    if (Get.isRegistered<CartController>()) {
      await Get.find<CartController>().loadCart();
    }

    Fluttertoast.showToast(msg: "🛒 Added $addedCount item(s) to Cart!");
  }

  /// Subscribe to restock alerts
  Future<void> notifyWhenInStock(String productId) async {
    final pid = int.tryParse(productId) ?? 0;
    if (pid <= 0) return;

    try {
      final success = await _repo.notifyMe(pid);
      if (success) {
        Fluttertoast.showToast(
          msg: "🔔 You'll receive an instant push notification when this item is restocked!",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to subscribe for restock alert");
    }
  }
}
