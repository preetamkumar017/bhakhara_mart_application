import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('Cart is empty'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (_, i) {
                  final item = controller.items[i];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.unit} • ₹${item.price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => controller.decreaseQty(item),
                        ),
                        Text(item.quantity.toInt().toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => controller.increaseQty(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.removeItem(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Total: ₹${controller.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
