import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/product_model.dart';
import 'package:bhakharamart/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return GestureDetector(
      onTap: () => controller.openProduct(product),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Center(child: Icon(Icons.image_outlined)),
            ),
            Text(
              product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.unit,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '₹${product.salePrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => controller.addToCart(product),
                  child: const Text('ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
