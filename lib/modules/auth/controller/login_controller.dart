import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/app_exception.dart';
import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/secure_token_storage.dart';
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
          await SecureTokenStorage.writeAccessToken(tokenValue);
        }
        if (refresh != null) {
          await SecureTokenStorage.writeRefreshToken(refresh);
        } else if (kDebugMode) {
          debugPrint('Warning: No refresh_token in login response');
        }
        await _storage.write('isLoggedIn', true);

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
      String errorMsg = 'Invalid mobile number or password.';
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

  @override
  void onClose() {
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
