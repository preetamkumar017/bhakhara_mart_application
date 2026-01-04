import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import '../../../data/models/product_model.dart';

class ProductDetailView extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(title: Text(product.productName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.unit, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              '₹${product.salePrice}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() => Row(
                  children: [
                    IconButton(
                      onPressed: controller.decreaseQty,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      controller.quantity.value.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: controller.increaseQty,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
