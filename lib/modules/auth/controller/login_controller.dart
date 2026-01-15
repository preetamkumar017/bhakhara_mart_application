import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../core/utils/snackbar.dart';
import '../../../res/routes/routes_name.dart';

class LoginController extends GetxController {
  final _apiService = NetworkApiServices();
  final _storage = GetStorage();

  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  void login() async {
    if (mobileController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      SnackBarUtils.showError('Please enter mobile and password');
      return;
    }

    final data = {
      "mobile": mobileController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      isLoading.value = true;

      final response = await _apiService.postApi(ApiEndpoints.login, data);

      isLoading.value = false;

      if (response['status'] == true) {
        // ✅ SAVE TOKEN (await to ensure it's persisted before next requests)
        final tokenValue = response['access_token'] ?? response['token'];
        final refresh = response['refresh_token'];

        if (tokenValue != null) {
          await _storage.write('token', tokenValue);
          await _storage.write('access_token', tokenValue);
        }
        if (refresh != null) {
          await _storage.write('refresh_token', refresh);
        } else {
          // If API doesn't return refresh_token, use existing one or null
          print('Warning: No refresh_token in login response');
        }
        await _storage.write('isLoggedIn', true);

        // Verify token was stored (debug)
        final stored = _storage.read('token') ?? _storage.read('access_token');
        print('Login: stored token = $stored');

        SnackBarUtils.showSuccess('Login successful');

        // ✅ NAVIGATE TO HOME
        Get.offAllNamed(RoutesName.home);
      } else {
        SnackBarUtils.showError(
          response['message'] ?? 'Invalid credentials',
        );
      }
    } catch (e) {
      isLoading.value = false;
      SnackBarUtils.showError(e.toString());
    }
  }

  @override
  void onClose() {
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
