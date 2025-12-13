import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_button.dart';
import '../controller/cart_controller.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return ListTile(
                      tileColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: Text('${item['name']}'),
                      subtitle: Text('Qty: ${item['qty']}'),
                      trailing: Text('₹${(item['qty'] as int) * (item['price'] as num)}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleLarge),
                  Text('₹${controller.total}', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              CustomButton(label: 'Checkout (COD)', onPressed: controller.checkout),
            ],
          );
        }),
      ),
    );
  }
}

