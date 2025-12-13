import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  static void showSuccess(String message) {
    _show(message, backgroundColor: Colors.green.shade600);
  }

  static void showError(String message) {
    _show(message, backgroundColor: Colors.red.shade600);
  }

  static void _show(String message, {required Color backgroundColor}) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }
}

