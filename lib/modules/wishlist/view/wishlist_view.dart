import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../../res/routes/routes_name.dart';
import '../../cart/controller/cart_controller.dart';
import '../../product/view/product_card.dart';
import '../controller/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  WishlistView({super.key});

  final WishlistController controller = Get.put(WishlistController());
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    controller.loadWishlist();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Favorites & Staples'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 72, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Your favorites list is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the heart ❤️ on your regular grocery items\nto easily re-order anytime!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(RoutesName.home),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Explore Groceries'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            /// Top Bar with Move All to Cart
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.wishlistItems.length} Saved Item(s)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => controller.addAllToCart(),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
                    label: const Text('Move All to Cart', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),

            /// Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.wishlistItems.length,
                itemBuilder: (_, index) {
                  final ProductModel product = controller.wishlistItems[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
