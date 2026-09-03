import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../repo/cart_repo.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/coupon_model.dart';
import '../../../data/models/product_model.dart';
import '../../../modules/home/controller/home_controller.dart';

class CartController extends GetxController {
  final CartRepo _repo = CartRepo();

  final items = <CartItemModel>[].obs;
  final isLoading = false.obs;
  final isCouponLoading = false.obs;

  // Coupon state
  final appliedCouponCode = ''.obs;
  final discountAmount = 0.0.obs;
  final appliedCoupon = Rxn<CouponModel>();
  final availableCoupons = <CouponModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    loadAvailableCoupons();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    try {
      items.assignAll(await _repo.fetchCart());
      // Re-validate coupon if already applied
      if (appliedCouponCode.value.isNotEmpty) {
        await _revalidateAppliedCoupon();
      }
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }

    _refreshHomeController();
  }

  Future<void> loadAvailableCoupons() async {
    try {
      final coupons = await _repo.fetchAvailableCoupons();
      availableCoupons.assignAll(coupons);
    } catch (e) {
      // ignore
    }
  }

  Future<bool> applyCoupon(String code) async {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid coupon code");
      return false;
    }

    if (items.isEmpty) {
      Fluttertoast.showToast(msg: "Cart is empty");
      return false;
    }

    isCouponLoading.value = true;
    try {
      final res = await _repo.validateCoupon(cleanCode, totalAmount);
      if (res['status'] == true && res['data'] != null) {
        final data = res['data'];
        final disc = double.tryParse(data['discount_amount']?.toString() ?? '0') ?? 0.0;
        
        appliedCouponCode.value = cleanCode;
        discountAmount.value = disc;
        appliedCoupon.value = CouponModel(
          code: cleanCode,
          discountName: data['discount_name']?.toString() ?? cleanCode,
          discountType: data['discount_type']?.toString() ?? 'FLAT',
          discountValue: double.tryParse(data['discount_value']?.toString() ?? '0') ?? disc,
          minOrderAmount: 0.0,
        );

        Fluttertoast.showToast(msg: "🎉 Coupon '$cleanCode' applied! You saved ₹${disc.toStringAsFixed(2)}");
        return true;
      } else {
        Fluttertoast.showToast(msg: res['message'] ?? "Invalid coupon code");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to apply coupon. Please check minimum order value.");
      return false;
    } finally {
      isCouponLoading.value = false;
    }
  }

  void removeCoupon() {
    appliedCouponCode.value = '';
    discountAmount.value = 0.0;
    appliedCoupon.value = null;
    Fluttertoast.showToast(msg: "Coupon removed");
  }

  Future<void> _revalidateAppliedCoupon() async {
    if (appliedCouponCode.value.isEmpty) return;
    try {
      final res = await _repo.validateCoupon(appliedCouponCode.value, totalAmount);
      if (res['status'] == true && res['data'] != null) {
        final data = res['data'];
        discountAmount.value = double.tryParse(data['discount_amount']?.toString() ?? '0') ?? 0.0;
      } else {
        // Minimum amount not met anymore
        removeCoupon();
      }
    } catch (e) {
      removeCoupon();
    }
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

  Future<void> addToCart(ProductModel product, {int qty = 1}) async {
    final pid = int.tryParse(product.id) ?? 0;
    if (pid > 0) {
      await _repo.addToCart(pid, qty);
      await loadCart();
    }
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

  double get totalAmount => items.fold(0, (sum, e) => sum + e.subtotal);

  double get deliveryCharge => 0.0; // Free delivery standard or configurable

  double get payableAmount => (totalAmount - discountAmount.value + deliveryCharge).clamp(0.0, double.infinity);

  // ================= CART STATE CHECK =================
  bool isInCart(String productId) {
    return items.any((item) => item.productId == productId);
  }

  CartItemModel? getCartItem(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }
}
