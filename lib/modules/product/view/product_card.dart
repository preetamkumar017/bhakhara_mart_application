import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/product_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/modules/home/controller/home_controller.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final CartController cartController = Get.find<CartController>();

    return GestureDetector(
      onTap: () => homeController.openProduct(product),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image
            Expanded(
              child: Center(
                child: product.image.isNotEmpty
                    ? Image.network(
                        '${ApiEndpoints.domain}/uploads/products/${product.image}',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image_outlined),
                      )
                    : const Icon(Icons.image_outlined),
              ),
            ),

            /// Product Name
            Text(
              product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            /// Unit
            Text(
              product.unit,
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 4),

            /// Price and Cart Action Row
            Row(
              children: [
                Text(
                  '₹${product.salePrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),

                /// Reactive cart state check using Obx
                Obx(() {
                  final bool isInCart =
                      cartController.isInCart(product.id);

                  if (isInCart) {
                    /// Product is in cart - show "Added" status
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Added',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  /// Product not in cart - show Add button
                  return ElevatedButton(
                    onPressed: () => homeController.addToCart(product),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(fontSize: 11),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
