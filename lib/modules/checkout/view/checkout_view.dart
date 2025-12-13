import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_button.dart';
import '../../../res/components/custom_textfield.dart';
import '../controller/checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  CheckoutView({super.key});

  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery address', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedAddress.value,
                items: controller.addresses
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.selectAddress(val);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              );
            }),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.landmarkController,
              hintText: 'Landmark (optional)',
            ),
            const Spacer(),
            CustomButton(
              label: 'Place COD Order',
              onPressed: controller.placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}

