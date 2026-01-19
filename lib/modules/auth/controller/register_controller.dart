import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../core/utils/snackbar.dart';
import '../../../res/routes/routes_name.dart';

class RegisterController extends GetxController {
  final _apiService = NetworkApiServices();
  final _storage = GetStorage();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  void register() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      SnackBarUtils.showError('Please enter your name');
      return;
    }

    if (mobileController.text.trim().isEmpty) {
      SnackBarUtils.showError('Please enter mobile number');
      return;
    }

    if (mobileController.text.trim().length != 10) {
      SnackBarUtils.showError('Please enter valid 10-digit mobile number');
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      SnackBarUtils.showError('Please enter password');
      return;
    }

    if (passwordController.text.trim().length < 6) {
      SnackBarUtils.showError('Password must be at least 6 characters');
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      SnackBarUtils.showError('Please confirm your password');
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      SnackBarUtils.showError('Passwords do not match');
      return;
    }

    final data = {
      "name": nameController.text.trim(),
      "mobile": mobileController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      isLoading.value = true;

      final response = await _apiService.postApi(ApiEndpoints.register, data);

      isLoading.value = false;

      if (response['status'] == true) {
        // ✅ SAVE TOKEN (await to ensure it's persisted before next requests)
        final tokenValue = response['access_token'];
        final refresh = response['refresh_token'];

        if (tokenValue != null) {
          await _storage.write('token', tokenValue);
          await _storage.write('access_token', tokenValue);
        }
        if (refresh != null) {
          await _storage.write('refresh_token', refresh);
        }
        await _storage.write('isLoggedIn', true);

        // Verify token was stored (debug)
        final stored = _storage.read('token') ?? _storage.read('access_token');
        print('Register: stored token = $stored');

        SnackBarUtils.showSuccess(response['message'] ?? 'Registration successful');

        // ✅ NAVIGATE TO HOME
        Get.offAllNamed(RoutesName.home);
      } else {
        SnackBarUtils.showError(
          response['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      isLoading.value = false;
      SnackBarUtils.showError(e.toString());
    }
  }

  void navigateToLogin() {
    Get.offNamed(RoutesName.login);
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

