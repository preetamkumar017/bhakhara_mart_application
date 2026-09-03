import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/app_exception.dart';
import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/secure_token_storage.dart';
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
          await SecureTokenStorage.writeAccessToken(tokenValue);
        }
        if (refresh != null) {
          await SecureTokenStorage.writeRefreshToken(refresh);
        }
        await _storage.write('isLoggedIn', true);

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
      String errorMsg = 'Registration failed. Please check your details.';
      if (e is ApiErrorException) {
        errorMsg = e.errorMessage.isNotEmpty ? e.errorMessage : errorMsg;
      } else if (e is InternetErrorException) {
        errorMsg = 'No internet connection. Please check your network.';
      } else {
        errorMsg = e.toString().replaceAll('Exception:', '').replaceAll('API Error', '').trim();
      }
      SnackBarUtils.showError(errorMsg);
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

