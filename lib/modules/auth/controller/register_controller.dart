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

  final isLoading = false.obs;

  /// All params passed from View's own TextEditingControllers
  Future<void> register({
    required String name,
    required String mobile,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.trim().isEmpty) {
      SnackBarUtils.showError('Please enter your name');
      return;
    }
    if (mobile.trim().isEmpty) {
      SnackBarUtils.showError('Please enter mobile number');
      return;
    }
    if (mobile.trim().length != 10) {
      SnackBarUtils.showError('Please enter valid 10-digit mobile number');
      return;
    }
    if (password.trim().isEmpty) {
      SnackBarUtils.showError('Please enter password');
      return;
    }
    if (password.trim().length < 6) {
      SnackBarUtils.showError('Password must be at least 6 characters');
      return;
    }
    if (confirmPassword.trim().isEmpty) {
      SnackBarUtils.showError('Please confirm your password');
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      SnackBarUtils.showError('Passwords do not match');
      return;
    }

    final data = {
      "name": name.trim(),
      "mobile": mobile.trim(),
      "password": password.trim(),
    };

    try {
      isLoading.value = true;

      final response = await _apiService.postApi(ApiEndpoints.register, data);

      if (response['status'] == true) {
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
        Get.offAllNamed(RoutesName.home);
      } else {
        SnackBarUtils.showError(
          response['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      String errorMsg = 'Registration failed. Please check your details.';
      if (e is ApiErrorException) {
        errorMsg = e.errorMessage.isNotEmpty ? e.errorMessage : errorMsg;
      } else if (e is InternetErrorException) {
        errorMsg = 'No internet connection. Please check your network.';
      } else {
        errorMsg = e.toString().replaceAll('Exception:', '').replaceAll('API Error', '').trim();
      }
      SnackBarUtils.showError(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    Get.offNamed(RoutesName.login);
  }
}
