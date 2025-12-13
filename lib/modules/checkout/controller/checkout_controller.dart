import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final addresses = [
    'Home - 221B Baker Street',
    'Office - Tech Park Tower',
    'Parents - MG Road'
  ];

  final selectedAddress = ''.obs;
  final landmarkController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    selectedAddress.value = addresses.first;
  }

  void selectAddress(String value) {
    selectedAddress.value = value;
  }

  void placeOrder() {
    Get.snackbar('Order', 'COD order placed at ${selectedAddress.value}');
  }

  @override
  void onClose() {
    landmarkController.dispose();
    super.onClose();
  }
}

