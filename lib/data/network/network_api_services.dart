import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bhakharamart/data/network/base_api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../app_exception.dart';
import 'api_endpoints.dart';
import 'secure_token_storage.dart';

class NetworkApiServices extends BaseApiServices {
  final _storage = GetStorage();
  
  // Flag to prevent concurrent refresh token calls
  static bool _isRefreshing = false;
  static List<Function()> _refreshQueue = [];

  // =========================
  // GET
  // =========================
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      if (kDebugMode) debugPrint('API GET $url');

      final response = await http
          .get(
        Uri.parse(url),
        headers: await _defaultHeaders(),
      )
          .timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        debugPrint('API GET $url -> ${response.statusCode}');
      }

      responseJson = await _handleResponse(response, () => getApi(url));
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // POST  ✅ (MOST IMPORTANT)
  // =========================
  @override
  Future<dynamic> postApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      if (kDebugMode) debugPrint('API POST $url');

      final response = await http
          .post(
        Uri.parse(url),
        headers: await _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        debugPrint('API POST $url -> ${response.statusCode}');
      }

      responseJson = await _handleResponse(response, () => postApi(url, body));
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // PUT
  // =========================
  @override
  Future<dynamic> putApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: await _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = await _handleResponse(response, () => putApi(url, body));
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // PATCH
  // =========================
  @override
  Future<dynamic> patchApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .patch(
        Uri.parse(url),
        headers: await _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = await _handleResponse(response, () => patchApi(url, body));
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // DELETE
  // =========================
  @override
  Future<dynamic> deleteApi(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(
        Uri.parse(url),
        headers: await _defaultHeaders(),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10));

      responseJson = await _handleResponse(response, () => deleteApi(url, body));
    } on SocketException {
      throw InternetErrorException("No Internet Connection");
    }
    return responseJson;
  }

  // =========================
  // DOWNLOAD (NOT USED YET)
  // =========================
  @override
  Future<dynamic> downloadApi(String url) async {
    throw UnimplementedError("downloadApi not implemented yet");
  }

  @override
  Future<dynamic> downloadFile(String url, String path) async {
    throw UnimplementedError("downloadFile not implemented yet");
  }

  @override
  Future<dynamic> downloadImage(String url, String path) async {
    throw UnimplementedError("downloadImage not implemented yet");
  }

  @override
  Future<dynamic> downloadPdf(String url, String path) async {
    throw UnimplementedError("downloadPdf not implemented yet");
  }

  // =========================
  // UPLOAD (MULTIPART – FUTURE)
  // =========================
  @override
  Future<dynamic> uploadApi(
      String url, Map<String, dynamic> body, List<File> files) async {
    throw UnimplementedError("uploadApi not implemented yet");
  }

  // =========================
  // HEADERS (CENTRAL PLACE)
  // =========================
  Future<Map<String, String>> _defaultHeaders() async {
    final token = await SecureTokenStorage.readAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // RESPONSE HANDLER WITH 401 HANDLING
  // =========================
  Future<dynamic> _handleResponse(
    http.Response response,
    Function() retryFn,
  ) async {
    // Parse response body as JSON if possible
    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
    } catch (e) {
      responseBody = response.body;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        // Handle API-level status field (like {"status": false, "message": "..."})
        if (responseBody is Map<String, dynamic>) {
          if (responseBody['status'] == false) {
            final message = responseBody['message'] ?? 'Request failed';
            throw ApiErrorException(message, responseBody);
          }
        }
        return responseBody;

      case 400:
        throw BadRequestException(response.body);

      case 401:
        // Token expired - try to refresh
        return await _handleUnauthorized(retryFn);

      case 403:
        // Handle 403 with JSON error message
        if (responseBody is Map<String, dynamic>) {
          final message = responseBody['message'] ?? 'Access denied';
          throw ApiErrorException(message, responseBody);
        }
        throw ForbiddenException(response.body);

      case 404:
        throw NotFoundException(response.body);

      case 500:
        throw ServerException(response.body);

      default:
        throw FetchDataException(
          "Error occurred with status code ${response.statusCode}",
        );
    }
  }

  // =========================
  // REFRESH TOKEN LOGIC
  // =========================
  Future<dynamic> _handleUnauthorized(Function() retryFn) async {
    final refreshToken = await SecureTokenStorage.readRefreshToken();

    // If no refresh token, user must login again
    if (refreshToken == null) {
      await _clearTokensAndLogout();
      throw UnauthorizedException("Session expired. Please login again.");
    }

    // If already refreshing, wait for it to complete
    if (_isRefreshing) {
      return await _waitForRefresh(retryFn);
    }

    try {
      _isRefreshing = true;

      // Call refresh token API
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.refreshToken),
            headers: _refreshHeaders(),
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        
        if (responseBody['status'] == true) {
          // ✅ Update tokens in storage
          final newAccessToken = responseBody['access_token'] ?? responseBody['token'];
          final newRefreshToken = responseBody['refresh_token'];

          if (newAccessToken != null) {
            await SecureTokenStorage.writeAccessToken(newAccessToken);
          }
          if (newRefreshToken != null) {
            await SecureTokenStorage.writeRefreshToken(newRefreshToken);
          }

          if (kDebugMode) debugPrint('Token refreshed successfully');

          // Execute queued retry callbacks
          _processRefreshQueue(true);

          // Retry the original request with new token
          return await retryFn();
        } else {
          // Refresh token invalid/expired
          await _clearTokensAndLogout();
          throw UnauthorizedException(responseBody['message'] ?? "Session expired. Please login again.");
        }
      } else {
        // Refresh API failed
        await _clearTokensAndLogout();
        throw UnauthorizedException("Session expired. Please login again.");
      }
    } catch (e) {
      // Refresh failed
      _processRefreshQueue(false);
      await _clearTokensAndLogout();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  // =========================
  // HELPER METHODS
  // =========================

  /// Headers for refresh token request (no auth needed)
  Map<String, String> _refreshHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Wait for ongoing refresh to complete, then retry
  Future<dynamic> _waitForRefresh(Function() retryFn) async {
    final completer = Completer<dynamic>();
    _refreshQueue.add(() async {
      try {
        final result = await retryFn();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    // Wait for the refresh to complete (max 15 seconds)
    return await completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw UnauthorizedException("Token refresh timed out. Please login again.");
      },
    );
  }

  /// Process queued retry callbacks
  void _processRefreshQueue(bool success) {
    for (final callback in _refreshQueue) {
      try {
        callback();
      } catch (e) {
        // Silently ignore queue errors
      }
    }
    _refreshQueue.clear();
  }

  /// Clear tokens and navigate to login
  Future<void> _clearTokensAndLogout() async {
    await SecureTokenStorage.clear();
    await _storage.write('isLoggedIn', false);

    // Navigate to login if not already there
    // Use Get.offAll to clear navigation stack
    Get.offAllNamed('/login');
  }
}

