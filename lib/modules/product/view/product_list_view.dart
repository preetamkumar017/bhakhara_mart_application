import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../res/routes/routes_name.dart';
import '../../../modules/cart/controller/cart_controller.dart';

class ProductListView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final String categoryId = args['categoryId'];
    final String categoryName = args['categoryName'];

    controller.loadProducts(categoryId);

    /// Get CartController for reactive cart state
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (_, index) {
            final ProductModel product = controller.products[index];

            /// Reactive cart state check
            final bool isInCart = cartController.isInCart(product.id);

            return ListTile(
              title: Text(product.productName),
              subtitle: Text('${product.unit}  •  ₹${product.salePrice}'),
              trailing: isInCart
                  ? const Icon(Icons.check_circle, color: Colors.green, size: 18)
                  : const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Get.toNamed(
                  RoutesName.productDetail,
                  arguments: product,
                );
              },
            );
          },
        );
      }),
    );
  }
}
