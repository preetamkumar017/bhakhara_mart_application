import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/cart_model.dart';
import 'package:bhakharamart/data/models/coupon_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import '../controller/cart_controller.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _couponInputController = TextEditingController();

  @override
  void dispose() {
    _couponInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return _buildEmptyCartView();
        }

        return Column(
          children: [
            /// Cart Items List & Cross-Sell Recommendations
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...controller.items.asMap().entries.map((entry) {
                    return _buildCartItem(entry.value, controller, entry.key);
                  }),
                  _buildRecommendationsSection(controller),
                ],
              ),
            ),

            /// Price Summary & Checkout Section
            _buildCheckoutSection(controller, context),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(CartController controller) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 8),
          const Text(
            'My Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.totalItems}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
      actions: [
        Obx(() => controller.items.isNotEmpty
            ? IconButton(
                onPressed: () => _showClearCartDialog(controller),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textSecondary,
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCartItem(
    CartItemModel item,
    CartController controller,
    int index,
  ) {
    if (kDebugMode) {
      debugPrint('${ApiEndpoints.domain}/uploads/products/${item.image}');
    }
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (_) async {
        return await _showRemoveItemDialog(item.name);
      },
      onDismissed: (_) {
        controller.removeItem(item);
        Get.snackbar(
          'Removed',
          '${item.name} removed from cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.textPrimary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: '${ApiEndpoints.domain}/uploads/products/${item.image}',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.card,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.unit.isNotEmpty)
                    Text(
                      item.unit,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            /// Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuantityButton(
                    icon: Icons.add,
                    onTap: () => controller.increaseQty(item),
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${item.quantity.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onTap: () => controller.decreaseQty(item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartController controller, BuildContext context) {
    return Obx(() {
      final double subtotal = controller.totalAmount;
      final double discount = controller.discountAmount.value;
      final double deliveryFee = controller.deliveryCharge;
      final double total = controller.payableAmount;
      final bool hasCoupon = controller.appliedCouponCode.value.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Coupon Section
            _buildCouponSection(controller, context, hasCoupon),

            const SizedBox(height: 12),

            /// Price Breakdown Details
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Items Subtotal', subtotal),
                  if (discount > 0) ...[
                    const SizedBox(height: 8),
                    _buildPriceRow(
                      'Promo Savings (${controller.appliedCouponCode.value})',
                      '-₹${discount.toStringAsFixed(2)}',
                      isDiscount: true,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Delivery Fee',
                    deliveryFee == 0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(2)}',
                    isFree: deliveryFee == 0,
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grand Total',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Cash On Delivery (COD)',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// Proceed to Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(RoutesName.checkout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Proceed to Checkout • ₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCouponSection(CartController controller, BuildContext context, bool hasCoupon) {
    if (hasCoupon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified, color: AppColors.success, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coupon '${controller.appliedCouponCode.value}' Applied!",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    "You saved ₹${controller.discountAmount.value.toStringAsFixed(2)} on this order",
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => controller.removeCoupon(),
              child: const Text(
                "REMOVE",
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: _couponInputController,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Enter Promo Code (e.g. WELCOME50)",
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 42,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isCouponLoading.value
                        ? null
                        : () async {
                            final success = await controller.applyCoupon(_couponInputController.text);
                            if (success) {
                              _couponInputController.clear();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: controller.isCouponLoading.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            "APPLY",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _showOffersBottomSheet(controller, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_offer_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                        controller.availableCoupons.isNotEmpty
                            ? "View ${controller.availableCoupons.length} Available Offers"
                            : "View Available Offers",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      )),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  void _showOffersBottomSheet(CartController controller, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_offer, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        "Available Offers & Coupons",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.availableCoupons.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        "No coupons available at the moment.",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.availableCoupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final coupon = controller.availableCoupons[index];
                    return _buildCouponCard(coupon, controller, context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCouponCard(CouponModel coupon, CartController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
            ),
            child: Text(
              coupon.code,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.discountName ?? coupon.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  coupon.description ?? "Min order: ₹${coupon.minOrderAmount.toInt()}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.applyCoupon(coupon.code);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text(
              "APPLY",
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, dynamic value, {bool isDiscount = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDiscount ? AppColors.success : AppColors.textSecondary,
          ),
        ),
        Text(
          value is String ? value : '₹${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? AppColors.success
                : (isFree ? AppColors.success : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Looks like you haven\'t added anything yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showRemoveItemDialog(String itemName) async {
    return await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Remove Item'),
            content: Text('Are you sure you want to remove $itemName from your cart?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildRecommendationsSection(CartController controller) {
    return Obx(() {
      if (controller.recommendations.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.amber),
                  SizedBox(width: 6),
                  Text(
                    'Frequently Bought Together',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 165,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.recommendations.length,
                itemBuilder: (_, index) {
                  final p = controller.recommendations[index];
                  return Container(
                    width: 125,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: p.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: '${ApiEndpoints.domain}/uploads/products/${p.image}',
                                    fit: BoxFit.contain,
                                    errorWidget: (_, __, ___) => const Icon(Icons.inventory_2_outlined, size: 30),
                                  )
                                : const Icon(Icons.inventory_2_outlined, size: 30),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          p.unit,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${p.salePrice.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            InkWell(
                              onTap: () {
                                controller.addToCart(p);
                                Fluttertoast.showToast(msg: "Added ${p.productName} to Cart");
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: const Text(
                                  '+ ADD',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showClearCartDialog(CartController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (var item in controller.items) {
                controller.removeItem(item);
              }
              Get.back();
              Get.snackbar(
                'Cart Cleared',
                'All items have been removed',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.textPrimary,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
