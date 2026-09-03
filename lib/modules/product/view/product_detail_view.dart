import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/product_model.dart';
import 'package:bhakharamart/data/models/product_variant_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';
import 'package:bhakharamart/modules/wishlist/controller/wishlist_controller.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import '../controller/product_controller.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.find<CartController>();
  final WishlistController wishlistController = Get.put(WishlistController());

  ProductModel? product;
  ProductVariantModel? selectedVariant;
  late double currentPrice;
  late String currentUnit;
  late double currentStock;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductModel?;
    if (product != null) {
      if (product!.variants.isNotEmpty) {
        selectedVariant = product!.variants.firstWhere(
          (v) => v.isDefault,
          orElse: () => product!.variants.first,
        );
        currentPrice = selectedVariant!.salePrice;
        currentUnit = selectedVariant!.variantName;
        currentStock = selectedVariant!.stockQty;
      } else {
        currentPrice = product!.salePrice;
        currentUnit = product!.unit;
        currentStock = product!.stockQty;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: Text('Product not found')),
      );
    }

    final p = product!;
    final bool isInStock = currentStock > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(p.productName),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          /// Wishlist Button
          Obx(() {
            final isFav = wishlistController.isFavorite(p.id) || p.isFavorite;
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.error : AppColors.textPrimary,
              ),
              onPressed: () => wishlistController.toggleWishlist(p),
              tooltip: 'Favorite',
            );
          }),

          /// Cart Button
          IconButton(
            onPressed: () => Get.toNamed(RoutesName.cart),
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Obx(() => cartController.totalItems > 0
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartController.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image Hero
            Container(
              height: 260,
              width: double.infinity,
              color: Colors.white,
              child: p.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: '${ApiEndpoints.domain}/uploads/products/${p.image}',
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// In-Stock / Out-of-Stock Badge & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isInStock ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isInStock ? Icons.check_circle : Icons.error_outline,
                              size: 14,
                              color: isInStock ? AppColors.success : AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isInStock ? 'IN STOCK' : 'OUT OF STOCK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isInStock ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '${p.averageRating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            ' (${p.reviewCount} reviews)',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Product Name
                  Text(
                    p.productName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),

                  const SizedBox(height: 8),

                  /// Price and Unit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($currentUnit)',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      if (selectedVariant?.mrp != null && selectedVariant!.mrp! > currentPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${selectedVariant!.mrp!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const Divider(height: 24),

                  /// Multi-Pack Variants Selector (if any)
                  if (p.variants.isNotEmpty) ...[
                    const Text(
                      'Select Pack Size / Weight',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: p.variants.map((variant) {
                        final isSelected = selectedVariant?.id == variant.id;
                        return ChoiceChip(
                          label: Text('${variant.variantName} • ₹${variant.salePrice.toStringAsFixed(0)}'),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedVariant = variant;
                              currentPrice = variant.salePrice;
                              currentUnit = variant.variantName;
                              currentStock = variant.stockQty;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const Divider(height: 24),
                  ],

                  /// Delivery Promise Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.amber, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Instant Delivery in 30-45 mins', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('Free delivery on orders above ₹499', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Reviews / Customer Feedback
                  _buildCustomerReviewsSection(p),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: isInStock
              ? Row(
                  children: [
                    /// Quantity Stepper
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Obx(() => Row(
                            children: [
                              IconButton(
                                onPressed: controller.decreaseQty,
                                icon: const Icon(Icons.remove, size: 18),
                              ),
                              Text(
                                '${controller.quantity.value}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                onPressed: controller.increaseQty,
                                icon: const Icon(Icons.add, size: 18),
                              ),
                            ],
                          )),
                    ),

                    const SizedBox(width: 12),

                    /// Add to Cart Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          cartController.addToCart(p);
                          Fluttertoast.showToast(msg: "Added '${p.productName}' to cart");
                        },
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        label: Text(
                          'Add to Cart • ₹${(currentPrice * controller.quantity.value).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                )
              : ElevatedButton.icon(
                  onPressed: () => wishlistController.notifyWhenInStock(p.id),
                  icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                  label: const Text('Notify Me When Available', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCustomerReviewsSection(ProductModel p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer Ratings & Feedback', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  const Text('100% Genuine & Fresh Quality Guaranteed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '"Consistently fresh groceries delivered in record time. Packaging is always clean and well maintained."',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
